//
//  ProfileView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-09-23.
//  Copyright © Goverland Inc. All rights reserved.
//

import SwiftUI
import SwiftDate

enum ProfileScreen {
    case settings
    case subscriptions

    // Settings
    case pushNofitications
    case about
    case helpUsGrow
    case partnership
    case advanced
}

struct ProfileView: View {
    @Binding var path: [ProfileScreen]
    @Setting(\.authToken) private var authToken

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                if authToken.isEmpty {
                    SignInView(source: .profile)
                } else {
                    _ProfileView()
                }
            }
            .id(authToken) // to forse proper refresh on sign out / sign in
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Profile")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        path.append(.settings)
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .navigationDestination(for: ProfileScreen.self) { profileScreen in
                switch profileScreen {
                case .settings: SettingsView()
                case .subscriptions: SubscriptionsView()

                    // Settings
                case .pushNofitications: PushNotificationsSettingView()
                case .about: AboutSettingView()
                case .helpUsGrow: HelpUsGrowSettingView()
                case .partnership: PartnershipSettingView()
                case .advanced: AdvancedSettingView()
                }
            }
        }
    }
}

fileprivate struct _ProfileView: View {
    @StateObject private var dataSource = ProfileDataSource.shared
    @State private var showSignIn = false

    var body: some View {
        Group {
            if dataSource.failedToLoadInitialData {
                RetryInitialLoadingView(dataSource: dataSource, message: "Sorry, we couldn’t load the profile")
            } else if dataSource.profile == nil { // is loading
                _ShimmerProfileHeaderView()
                Spacer()
            } else if let profile = dataSource.profile {
                _ProfileHeaderView(user: profile.account)

                FilterButtonsView<ProfileFilter>(filter: $dataSource.filter) { _ in }

                switch dataSource.filter {
                case .activity:
                    if profile.role == .guest {
                        _SignInToVoteButton {
                            showSignIn = true
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }

                    _ProfileListView(profile: profile)
                case .achievements: 
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showSignIn) {
            SignInTwoStepsView()
                .presentationDetents([.height(500), .large])
        }
        .onAppear {
            Tracker.track(.screenProfile)
            if dataSource.profile == nil {
                dataSource.refresh()
            }
        }
    }

    struct _SignInToVoteButton: View {
        let action: () -> Void

        var body: some View {
            Button(action: {
                action()
            }) {
                HStack {
                    Text("Sign in to vote")
                    Spacer()
                }
                .frame(height: 54)
                .padding(.horizontal, 16)
                .background(Color.primary)
                .cornerRadius(12)
                .tint(.onPrimary)
                .font(.headlineSemibold)
            }
        }
    }
}

fileprivate struct _ProfileHeaderView: View {
    let user: User?

    var body: some View {
        VStack(alignment: .center) {
            VStack(spacing: 12) {
                if let user {
                    RoundPictureView(image: user.avatar(size: .l), imageSize: Avatar.Size.l.profileImageSize)
                    ZStack {
                        if let name = user.resolvedName {
                            Text(name)
                                .truncationMode(.tail)
                        } else {
                            Button {
                                UIPasteboard.general.string = user.address.value
                                showToast("Address copied")
                            } label: {
                                Text(user.address.short)
                            }
                        }
                    }
                    .font(.title3Semibold)
                    .lineLimit(1)
                    .foregroundStyle(Color.textWhite)
                } else { // Guest profile
                    Image("guest-profile")
                        .frame(width: Avatar.Size.l.profileImageSize, height: Avatar.Size.l.profileImageSize)
                        .scaledToFit()
                        .clipShape(Circle())
                    Text("Guest")
                        .font(.title3Semibold)
                        .foregroundStyle(Color.textWhite)
                }
            }
            .padding(.bottom, 6)
        }
        .padding(24)
    }

    struct CounterView: View {
        let counter: Int
        let title: String

        var body: some View {
            VStack(spacing: 4) {
                Text("\(counter)")
                    .font(.bodySemibold)
                    .foregroundStyle(Color.textWhite)
                Text(title)
                    .font(.bodyRegular)
                    .foregroundStyle(Color.textWhite60)
            }
        }
    }
}


fileprivate struct _ShimmerProfileHeaderView: View {
    var body: some View {
        VStack(alignment: .center) {
            ShimmerView()
                .frame(width: Avatar.Size.l.profileImageSize, height: Avatar.Size.l.profileImageSize)
                .cornerRadius(Avatar.Size.l.profileImageSize / 2)

            ShimmerView()
                .cornerRadius(24)
                .frame(width: 100, height: 24)
        }
        .padding(24)
    }
}

fileprivate struct _ProfileListView: View {
    let profile: Profile

    var body: some View {
        ScrollView {
            _ProfileSubscriptionsView(profile: profile)

            if let user = profile.account {
                _ConnectedWalletView(user: user)
            }
        }
        .refreshable {
            ProfileDataSource.shared.refresh()
        }
    }
}

fileprivate struct _ProfileSubscriptionsView: View {
    let profile: Profile

    var body: some View {
        if profile.subscriptionsCount > 0 {
            VStack(spacing: 12) {
                HStack {
                    Text("My followed DAOs (\(profile.subscriptionsCount))")
                        .font(.subheadlineSemibold)
                        .foregroundColor(.textWhite)
                    Spacer()
                    NavigationLink("See all", value: ProfileScreen.subscriptions)
                        .font(.subheadlineSemibold)
                        .foregroundColor(.primaryDim)
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)

                DashboardPopularDaosHorizontalListView()
            }
        } else {
            NavigationLink(value: ProfileScreen.subscriptions) {
                HStack {
                    Text("My followed DAOs")
                    Spacer()
                    Text("\(profile.subscriptionsCount)")
                        .foregroundStyle(Color.textWhite60)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.textWhite60)
                }
                .padding(16)
            }
            .background(Color.container)
            .cornerRadius(12)
            .padding(.horizontal, 8)
            .padding(.top, 16)
        }
    }
}

fileprivate struct _ConnectedWalletView: View {
    let user: User
    @State private var wcViewId = UUID()
    @State private var showReconnectWallet = false

    private struct ConnectedWallet {
        let image: Image?
        let imageURL: URL?
        let name: String
        let sessionExpiryDate: Date?
        let redirectUrl: URL?
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Connected wallet")
                .font(.subheadlineSemibold)
                .foregroundColor(.textWhite)
                .padding(.top, 16)
                .padding(.horizontal, 16)

            Group {
                if let wallet = connectedWallet() {
                    _SwipeableConnectedWalletView(wallet: wallet)
                } else {
                    Button {
                        showReconnectWallet = true
                    } label: {
                        HStack {
                            Text("Reconnect wallet")
                            Spacer()
                        }
                    }
                    .padding(16)
                }
            }
            .background(Color.container)
            .cornerRadius(12)
            .padding(.horizontal, 8)
        }
        .id(wcViewId)
        .onReceive(NotificationCenter.default.publisher(for: .wcSessionUpdated)) { notification in
            // update "Connected wallet" view on session updates
            wcViewId = UUID()
        }
        .onReceive(NotificationCenter.default.publisher(for: .cbWalletAccountUpdated)) { notification in
            // update "Connected wallet" view on session updates
            wcViewId = UUID()
        }
        .sheet(isPresented: $showReconnectWallet) {
            ReconnectWalletView(user: user)
        }
    }

    private func connectedWallet() -> ConnectedWallet? {
        if CoinbaseWalletManager.shared.account != nil {
            let cbWallet = Wallet.coinbase
            return ConnectedWallet(
                image: Image(cbWallet.image),
                imageURL: nil,
                name: cbWallet.name,
                sessionExpiryDate: nil, 
                redirectUrl: cbWallet.link)
        }

        guard let sessionMeta = WC_Manager.shared.sessionMeta, !sessionMeta.isExpired else { return nil }

        let session = sessionMeta.session
        let image: Image?
        let imageUrl: URL?
        let redirectUrl: URL?

        if let imageName = Wallet.by(name: session.peer.name)?.image {
            image = Image(imageName)
        } else {
            image = nil
        }

        if let icon = session.peer.icons.first, let url = URL(string: icon) {
            imageUrl = url
        } else {
            imageUrl = nil
        }

        // custom adjustment for popular wallets
        var name = session.peer.name
        if name == "🌈 Rainbow" {
            name = "Rainbow"
        }

        if let url = session.peer.redirect?.universal {
            redirectUrl = URL(string: url)
        } else {
            redirectUrl = nil
        }

        return ConnectedWallet(image: image,
                               imageURL: imageUrl,
                               name: name,
                               sessionExpiryDate: session.expiryDate,
                               redirectUrl: redirectUrl)
    }
    
    /// Simulation of system List swipeActions
    private struct _SwipeableConnectedWalletView: View {
        let wallet: ConnectedWallet
        @State private var offset = CGFloat.zero
        @State private var showSheet = false
        let buttonWidth: CGFloat = 72
        let height: CGFloat = 72

        var body: some View {
            GeometryReader { geometry in
                HStack {
                    HStack(spacing: 12) {
                        if let image = wallet.image {
                            image
                                .frame(width: 32, height: 32)
                                .scaledToFit()
                                .cornerRadius(4)
                        } else if let imageUrl = wallet.imageURL {
                            SquarePictureView(image: imageUrl, imageSize: 32)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(wallet.name)
                                .font(.bodyRegular)
                                .foregroundColor(.textWhite)

                            if let date = wallet.sessionExpiryDate?.toRelative(since:  DateInRegion(), dateTimeStyle: .numeric, unitsStyle: .full) {
                                Text("Session expires \(date)")
                                    .font(.footnoteRegular)
                                    .foregroundColor(.textWhite60)
                            }
                        }

                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .padding(16)
                    .frame(width: geometry.size.width, alignment: .leading)
                    .offset(x: self.offset, y: 0)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if gesture.translation.width < 0 { // swipe left
                                    offset = min(offset, gesture.translation.width)
                                } else { // swipe right
                                    withAnimation {
                                        self.offset = CGFloat.zero
                                    }
                                }
                            }
                            .onEnded { _ in
                                if offset < -buttonWidth {
                                    withAnimation {
                                        offset = -buttonWidth
                                    }
                                } else {
                                    withAnimation {
                                        offset = .zero
                                    }
                                }
                            }
                    )
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded {
                                if offset == 0 {
                                    showSheet = true
                                }
                            }
                    )

                    HStack {
                        Spacer()
                        Image(systemName: "network.slash")
                            .foregroundStyle(Color.textWhite)
                            .font(.system(size: 26))
                        Spacer()
                    }
                    .frame(width: -offset > buttonWidth ? -offset : buttonWidth, height: height)
                    .contentShape(Rectangle())
                    .background(Color.red)
                    .offset(x: offset)
                    .onTapGesture {
                        disconnect()
                    }
                }
            }
            .frame(height: height)
            .actionSheet(isPresented: $showSheet) {
                var alertButtons = [Alert.Button]()
                if let redirectUrl = wallet.redirectUrl {
                    alertButtons.append(
                        .default(Text("Open wallet")) {
                            openUrl(redirectUrl)
                        }
                    )
                }
                alertButtons.append(
                    .destructive(Text("Disconnect")) {
                        disconnect()
                    }
                )
                alertButtons.append(.cancel())
                return ActionSheet(title: Text(wallet.name),
                                   message: nil,
                                   buttons: alertButtons)
            }
        }

        private func disconnect() {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()

            if wallet.name == Wallet.coinbase.name {
                CoinbaseWalletManager.disconnect()
                Tracker.track(.disconnectCoinbaseWallet)
            } else {
                guard let topic = WC_Manager.shared.sessionMeta?.session.topic else { return }
                WC_Manager.disconnect(topic: topic)
                Tracker.track(.disconnect_WC_session)
            }
        }
    }
}
