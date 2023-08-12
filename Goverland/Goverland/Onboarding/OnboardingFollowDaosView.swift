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

                                        onSelectDaoFromGroup: nil,
                                        onSelectDaoFromCategoryList: nil,
                                        onSelectDaoFromCategorySearch: nil,

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
                            .background(Color(.systemBackground).opacity(0.8))
                            .navigationDestination(for: String.self) { _ in
                                EnablePushNotificationsView()
                            }
                        }
                    } else {
                        RetryInitialLoadingView(dataSource: dataSource)
                    }
                } else {
                    DaosSearchListView(dataSource: dataSource,
                                       onSelectDao: nil,
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
            }
            .refreshable {
                dataSource.refresh()
            }
            .onAppear() {
                dataSource.refresh()
                Tracker.track(.screenOnboardingFollowDaos)
            }
        }
        .accentColor(.primary)
    }
}

struct SelectDAOsView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFollowDaosView()
    }
}
