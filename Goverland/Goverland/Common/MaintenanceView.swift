//
//  MaintenanceView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-02-22.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct MaintenanceView: View {
    var body: some View {
        VStack {
            MaintenanceHeaderView()
            Spacer()
            MaintenanceBackgroundView()
            Spacer()
            MaintenanceFooterControlsView()
        }
        .padding([.horizontal, .top])
        .onAppear() {Tracker.track(.screenMaintenance)}
    }
}

fileprivate struct MaintenanceHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: -15) {
                    Text("App is under")
                        .foregroundStyle(Color.textWhite)
                    Text("maintenance")
                        .foregroundStyle(Color.primaryDim)
                }
                .font(.chillaxMedium(size: 46))
                .kerning(-2.5)
                
                Spacer()
            }
            
            HStack {
                Text("It will be back soon, better than before. You can request support on ") +
                Text("Discord")
                    .underline(true, color: .primaryDim)
                    .foregroundColor(.primaryDim)
            }
            .lineLimit(3)
            .multilineTextAlignment(.leading)
            .foregroundStyle(Color.textWhite)
            .font(.chillaxRegular(size: 17))
            .onTapGesture {
                Tracker.track(.maintenanceScreenOpenDiscord)
                Utils.openDiscord()
            }
        }
    }
}

fileprivate struct MaintenanceBackgroundView: View {
    var body: some View {
        Image("maintenance-background")
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 50)
    }
}

fileprivate struct MaintenanceFooterControlsView: View {
    var body: some View {
        VStack(spacing: 20) {
            SecondaryButton("Subscribe on X") {
                Tracker.track(.maintenanceScreenOpenX)
                Utils.openX()
            }
        }
        .padding(.bottom, getPadding())
    }
}

fileprivate func getPadding() -> CGFloat {
    if UIDevice.current.userInterfaceIdiom == .phone && UIScreen.isSmall {
        return 0
    } else {
        return 80
    }
}
