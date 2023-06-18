//
//  InboxFilterMenuView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI

enum FilterType: Int, Identifiable {
    var id: Int { self.rawValue }

    case all = 0
    case vote
    case treasury

    static var allFilters: [FilterType] {
        return [.all, .vote, .treasury]
    }

    var localizedName: String {
        switch self {
        case .all:
            return "All"
        case .vote:
            return "Vote"
        case .treasury:
            return "Treasury"
        }
    }
}

struct InboxFilterMenuView: View {
    @Binding var filter: FilterType
    @Namespace var namespace

    let data: InboxDataService
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(FilterType.allFilters) { filterOption in
                    ZStack {
                        if filter == filterOption {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.primary)
                                .frame(height: 40)
                                .matchedGeometryEffect(id: "filter-background", in: namespace)
                        }
                        Text(filterOption.localizedName)
                            .padding(20)
                            .font(.footnoteSemibold)
                            .foregroundColor(filterOption == filter ? .surfaceBright : .textWhite)
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5)) {
                            self.filter = filterOption
                        }
                        data.refresh(withFilter: filterOption)
                    }
                    .padding([.leading, .trailing], 12)
                }
            }
        }
    }
}


struct InboxFilterMenu_Previews: PreviewProvider {
    static var previews: some View {
        InboxFilterMenuView(filter: .constant(.vote), data: InboxDataService())
    }
}
