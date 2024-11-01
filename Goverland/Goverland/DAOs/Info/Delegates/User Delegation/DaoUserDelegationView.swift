//
//  DaoUserDelegationView.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 27.06.24.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import SwiftData

struct DaoUserDelegationView: View {
    @StateObject private var dataSource: DaoUserDelegationDataSource
    @StateObject private var activeSheetManager: ActiveSheetManager
    @Query private var profiles: [UserProfile]

    init(dao: Dao, delegate: User) {
        let dataSource = DaoUserDelegationDataSource(dao: dao, delegate: delegate)
        _dataSource = StateObject(wrappedValue: dataSource)
        _activeSheetManager = StateObject(wrappedValue: ActiveSheetManager())
    }

    private var appUser: User {
        let profile = profiles.first(where: { $0.selected })!
        return profile.user
    }

    var body: some View {
        VStack {
            if dataSource.txHash == nil {
                Text("Delegate")
                    .font(.title3Semibold)
                    .foregroundStyle(Color.textWhite)
            }

            if dataSource.isLoading {
                ProgressView()
                    .foregroundStyle(Color.textWhite20)
                    .controlSize(.regular)
                Spacer()
            } else if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the delegation information")
            } else if let txHash = dataSource.txHash, let selectedChain = dataSource.selectedChain {
                DelegationSuccessView(chainId: selectedChain.id, txHash: txHash, txScanTemplate: selectedChain.txScanTemplate)
            } else if dataSource.userDelegation != nil {
                _DaoUserDelegationView(appUser: appUser, dataSource: dataSource)
                    .environmentObject(activeSheetManager)
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.top, 24)
        .padding(.bottom, 16)
        .overlay {
            InfoAlertView()
                .environmentObject(activeSheetManager)
        }
        .overlay {
            ToastView()
                .environmentObject(activeSheetManager)
        }
        .onAppear() {
            Tracker.track(.screenSplitDelegationAction)
            if dataSource.userDelegation == nil {
                dataSource.refresh()
            }
        }
    }
}

fileprivate struct _DaoUserDelegationView: View {
    let appUser: User
    @ObservedObject private var dataSource: DaoUserDelegationDataSource
    @StateObject private var splitViewModel: UserDelegationSplitViewModel

    @Namespace var namespace
    @Environment(\.dismiss) private var dismiss

    init(appUser: User, dataSource: DaoUserDelegationDataSource) {
        self.appUser = appUser
        _dataSource = ObservedObject(wrappedValue: dataSource)
        let splitViewModel = UserDelegationSplitViewModel(dao: dataSource.dao,
                                                          owner: appUser,
                                                          userDelegation: dataSource.userDelegation!,
                                                          delegate: dataSource.delegate)
        _splitViewModel = StateObject(wrappedValue: splitViewModel)
    }

    private var userDelegation: DaoUserDelegation! {
        dataSource.userDelegation
    }

    private var dao: Dao {
        dataSource.dao
    }

    private var delegate: User {
        dataSource.delegate
    }

    private var isConfirmEnabled: Bool {
        splitViewModel.isConfirmEnabled &&
        !dataSource.isPreparingRequest &&
        dataSource.selectedChainIsApprovedByWallet
    }

    private var selectedChainName: String {
        dataSource.selectedChain?.name ?? "unknown chain"
    }

    var body: some View {
        let connectedWallet = ConnectedWallet.current()
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                HStack {
                    Text("Selected wallet")
                        .font(.bodyRegular)
                        .foregroundStyle(Color.textWhite)

                    Spacer()


                    if let walletImage = connectedWallet?.image {
                        walletImage
                            .frame(width: Avatar.Size.xs.profileImageSize, height: Avatar.Size.xs.profileImageSize)
                            .scaledToFit()
                            .clipShape(Circle())
                    } else if let walletImageUrl = connectedWallet?.imageURL {
                        RoundPictureView(image: walletImageUrl, imageSize: Avatar.Size.s.profileImageSize)
                    }

                    IdentityView(user: appUser, size: .xs, font: .bodyRegular, onTap: nil)
                }

                HStack {
                    Text("Voting power")
                        .font(.bodyRegular)
                        .foregroundColor(.textWhite)
                    Spacer()

                    HStack(spacing: 4) {
                        Text(Utils.formattedNumber(userDelegation.votingPower.power))
                        Text(userDelegation.votingPower.symbol)
                    }
                    .font(.bodyRegular)
                    .foregroundColor(.textWhite)
                }

                Divider()
                    .background(Color.secondaryContainer)
                    .padding(.vertical)

                HStack {
                    Text("Delegation scope")
                        .font(.bodyRegular)
                        .foregroundColor(.textWhite)
                    Spacer()
                    HStack {
                        RoundPictureView(image: dao.avatar(size: .xs), imageSize: Avatar.Size.xs.daoImageSize)
                        Text(dao.name)
                            .font(.bodySemibold)
                            .foregroundStyle(Color.textWhite)
                    }
                }

                VStack {
                    HStack {
                        Text("Network")
                            .font(.bodyRegular)
                            .foregroundColor(.textWhite)
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(Color.textWhite40)
                            .padding(.trailing)
                            .onTapGesture() {
                                showInfoAlert("The delegation registry is stored on the blockchain. You can delegate on Gnosis Chain or Ethereum, but only the latest delegation is valid. Gnosis Chain transactions are cheaper than Ethereum's.")
                            }
                        Spacer()
                        HStack {
                            let chains = [userDelegation.chains.gnosis, userDelegation.chains.eth]
                            ForEach(chains) { chain in
                                ZStack {
                                    if dataSource.selectedChain == chain {
                                        Text(chain.name)
                                            .foregroundColor(.clear)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color.secondaryContainer)
                                            .cornerRadius(20)
                                            .matchedGeometryEffect(id: "network-background", in: namespace)
                                    }

                                    Text(chain.name)
                                        .foregroundColor(Color.onSecondaryContainer)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.secondaryContainer, lineWidth: 1)
                                        )
                                }
                                .font(.caption2Semibold)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.5)) {
                                        dataSource.selectedChain = chain
                                    }
                                }
                            }
                        }
                    }

                    if let connectedWallet, !dataSource.selectedChainIsApprovedByWallet {
                        let warningMessage = connectedWallet.warningMarkdownMessageForNotConnectedChain(chainName: selectedChainName)
                        let buttonTitle = connectedWallet.redirectUrl != nil ? "Open wallet" : nil
                        WarningView(markdown: warningMessage, actionButtonTitle: buttonTitle) {
                            guard let redirectUrl = connectedWallet.redirectUrl else { return }
                            openUrl(redirectUrl)
                        }
                    } else if !dataSource.isEnoughBalance {
                        WarningView(markdown: "You don’t have enough gas token for this transaction. Top up your wallet balance for at least **\(Utils.roundedUp(dataSource.deltaBalance)) \(dataSource.selectedChain?.symbol ?? "")**")
                    }

                    if let message = dataSource.infoMessage {
                        InfoMessageView(message: message)
                            .padding(.vertical, 20)
                    }
                }

                UserDelegationSplitVotingPowerView(viewModel: splitViewModel)
                    .padding(.bottom)

                SetDelegateExpirationView(dataSource: dataSource)
                    .padding(.bottom, 30)
            }
        }

        HStack {
            HStack {
                SecondaryButton("Cancel") {
                    dismiss()
                }

                PrimaryButton("Confirm", isEnabled: isConfirmEnabled) {
                    Haptic.medium()
                    dataSource.prepareSplitDelegation(splitModel: splitViewModel)
                }
            }
        }
    }
}

fileprivate struct WarningView: View {
    let markdown: String
    let actionButtonTitle: String?
    let action: (() -> Void)?

    init(markdown: String, actionButtonTitle: String? = nil, action: (() -> Void)? = nil) {
        self.markdown = markdown
        self.actionButtonTitle = actionButtonTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: 20) {
            GMarkdown(markdown)

            if let actionButtonTitle {
                HStack {
                    Spacer()
                    SecondaryButton(actionButtonTitle, maxWidth: 200, height: 32, font: .footnoteSemibold) {
                        action?()
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.containerBright)
        .cornerRadius(13)
    }
}
