//
//  ActivityFilterMenuView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI

struct ActivityFilterMenuView: View {
    @Binding var filter: FilterType
    @Namespace var namespace
    var data: ActivityDataService
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(FilterType.allFilters) { filterOption in
                    ZStack {
                        if filter == filterOption {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.green)
                                .frame(height: 40)
                                .matchedGeometryEffect(id: "filter-background", in: namespace)
                        }
                        
                        Text(filterOption.localizedName)
                            .padding(20)
                            .fontWeight(.bold)
                            .foregroundColor(filterOption == filter ? .black : .white)
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            self.filter = filterOption
                        }
                        data.getEvents(withFilter: filterOption, fromStart: true)
                    }
                        .padding([.leading, .trailing], 20)
                        
                }
            }
        }
        .padding(.leading, 15)
        .padding(.top, 60)
        .padding(.bottom, 10)
        .background(Color("lightGray-darkGray"))
    }
       
}



struct ActivityFilterMenu_Previews: PreviewProvider {
    static var previews: some View {
        ActivityFilterMenuView(filter: .constant(.vote), data: ActivityDataService())
    }
}
