//
//  OnboardingFollowDaosView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-30.
//

import SwiftUI

struct OnboardingFollowDaosView: View {
    @StateObject private var dataSource = GroupedDaosDataSource()
    @State private var path = NavigationPath()
    @EnvironmentObject private var activeSheetManger: ActiveSheetManager
    @State private var showSignIn = false

    private var searchPrompt: String {
        if let total = dataSource.totalDaos.map(String.init) {
            return "Search for \(total) DAOs by name"
        }
        return ""
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                if dataSource.searchText == "" {
                    if !dataSource.failedToLoadInitially {
                        GroupedDaosView(dataSource: dataSource,
                                        callToAction: "Receive updates for the DAOs you select.",

                                        onSelectDaoFromGroup: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.onboardingOpenDaoFromCard) },
                                        onSelectDaoFromCategoryList: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.onboardingOpenDaoFromCtgList) },
                                        onSelectDaoFromCategorySearch: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.onboardingOpenDaoFromCtgSearch) },

                                        onFollowToggleFromCard: { if $0 { Tracker.track(.onboardingFollowFromCard) } },
                                        onFollowToggleFromCategoryList: { if $0 { Tracker.track(.onboardingFollowFromCtgList) } },
                                        onFollowToggleFromCategorySearch: { if $0 { Tracker.track(.onboardingFollowFromCtgSearch) } },

                                        onCategoryListAppear: { Tracker.track(.screenOnboardingCategoryDaos) })


                        VStack {
                            Spacer()
                            PrimaryButton("Continue",
                                          isEnabled: dataSource.subscriptionsCount > 0,
                                          disabledText: "Follow a DAO to continue") {
                                path.append("EnablePushNotificationsView")
                            }
                            .padding()
                            .background(Color(.systemBackground)
                                .opacity(0.8)
                                .clipShape(TopRoundedCorner(radius: 20))
                                .ignoresSafeArea()
                            )
                            .navigationDestination(for: String.self) { _ in
                                EnablePushNotificationsView()
                            }
                        }
                    } else {
                        RetryInitialLoadingView(dataSource: dataSource)
                    }
                } else {
                    DaosSearchListView(dataSource: dataSource,
                                       onSelectDao: { dao in activeSheetManger.activeSheet = .daoInfo(dao); Tracker.track(.onboardingOpenDaoFromSearch) },
                                       onFollowToggle: { didFollow in
                        if didFollow {
                            Tracker.track(.onboardingFollowFromSearch)
                        }
                    })
                }
            }
            .searchable(text: $dataSource.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: searchPrompt)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Follow DAOs")
                            .font(.title3Semibold)
                            .foregroundColor(Color.textWhite)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign In") {
                        showSignIn = true
                    }
                }
            }
            .refreshable {
                dataSource.refresh()
            }
            .sheet(isPresented: $showSignIn) {
                TwoStepsModalView()
                    .presentationDetents([.medium, .large])
            }
            .onAppear() {
                dataSource.refresh()
                Tracker.track(.screenOnboardingFollowDaos)
            }
        }
        .accentColor(.primary)
    }
}

fileprivate struct TopRoundedCorner: Shape {
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addQuadCurve(to: CGPoint(x: rect.minX + radius, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + radius), control: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
