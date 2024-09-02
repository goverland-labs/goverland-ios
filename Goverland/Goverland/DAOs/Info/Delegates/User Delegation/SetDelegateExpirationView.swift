//
//  SetDelegateExpirationView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI

struct SetDelegateExpirationView: View {
    let dao: Dao

    @State private var isChecked = false
    @State private var selectedDate = Date()
    @State private var isDatePickerPresented = false
    @State private var isTooltipVisible = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Set expiration")
                    .font(.bodyRegular)
                    .foregroundColor(.textWhite)
                Image(systemName: "questionmark.circle")
                    .foregroundStyle(Color.textWhite40)
                    .padding(.trailing)
                    .tooltip($isTooltipVisible, side: .topRight, width: 200) {
                        Text("You can set an expiration date for your delegation and change your delegates or the expiration date at any time. Once the expiration date is reached, your delegation for \(dao.name) will be revoked")
                            .foregroundStyle(Color.textWhite60)
                            .font(.сaptionRegular)
                    }
                    .onTapGesture() {
                        withAnimation {
                            isTooltipVisible.toggle()
                            // Show tooltip for 5 sec only
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                if isTooltipVisible {
                                    isTooltipVisible.toggle()
                                }
                            }
                        }
                    }
                Spacer()
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? .primary : .white)
                    .onTapGesture {
                        isChecked.toggle()
                    }
            }
            
            if isChecked {
                HStack {
                    Image(systemName: "calendar")
                    Text(Utils.monthAndDayAndYear(selectedDate))
                    Spacer()
                }
                .padding()
                .frame(height: 40)
                .background(Capsule().stroke(Color.textWhite40, lineWidth: 1))
                .onTapGesture {
                    isDatePickerPresented.toggle()
                }
                .sheet(isPresented: $isDatePickerPresented) {
                    DatePickerView(selectedDate: $selectedDate, isPresented: $isDatePickerPresented)
                }
            }
        }
    }
}

fileprivate struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            // TODO: improve time interval
            DatePicker("Select a date", selection: $selectedDate, in: Date().addingTimeInterval(86400)..., displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            Spacer()
            
            PrimaryButton("Confirm") {
                isPresented = false
            }
        }
        .navigationBarTitle("Select Date", displayMode: .inline)
        .padding()
    }
}
