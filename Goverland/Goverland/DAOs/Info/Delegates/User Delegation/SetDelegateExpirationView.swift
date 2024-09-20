//
//  SetDelegateExpirationView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-07-11.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import SwiftUI
import SwiftDate

struct SetDelegateExpirationView: View {
    @ObservedObject var dataSource: DaoUserDelegationDataSource

    @State private var isChecked = false {
        didSet {
            if isChecked {
                // by default set it 1 year ahead
                dataSource.expirationDate = Calendar.current.startOfDay(for: .now + 1.days) + 1.years + 12.hours
                logInfo("[App] Set delegation expiration date: \(dataSource.expirationDate!)")
            } else {
                dataSource.expirationDate = nil
            }
        }
    }
    @State private var isDatePickerPresented = false

    var body: some View {
        VStack {
            HStack {
                Text("Set expiration")
                    .font(.bodyRegular)
                    .foregroundColor(.textWhite)
                Image(systemName: "questionmark.circle")
                    .foregroundStyle(Color.textWhite40)
                    .padding(.trailing)                    
                    .onTapGesture() {
                        showInfoAlert("You can set an expiration date for your delegation and change your delegates or the expiration date at any time. Once the expiration date is reached, your delegation for \(dataSource.dao.name) will be revoked.")
                    }
                Spacer()
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? .primary : .white)
                    .onTapGesture {
                        isChecked.toggle()
                    }
            }
            
            if let expirationDate = dataSource.expirationDate, isChecked {
                HStack {
                    Image(systemName: "calendar")
                    Text(Utils.monthAndDayAndYear(expirationDate))
                    Spacer()
                }
                .padding()
                .frame(height: 40)
                .background(Capsule().stroke(Color.textWhite40, lineWidth: 1))
                .onTapGesture {
                    isDatePickerPresented.toggle()
                }
                .sheet(isPresented: $isDatePickerPresented) {
                    DatePickerView(date: expirationDate) { date in
                        if let date {
                            dataSource.expirationDate = date
                            logInfo("[App] Set delegation expiration date: \(dataSource.expirationDate!)")
                        }
                    }
                }
            }
        }
    }
}

fileprivate struct DatePickerView: View {
    @State var date: Date
    var onConfirm: (Date?) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            let tomorrowStartOfDay = Calendar.current.startOfDay(for: .now + 1.days)
            DatePicker("Select a date", selection: $date, in: tomorrowStartOfDay..., displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
            
            Spacer()

            HStack(spacing: 12) {
                SecondaryButton("Cancel") {
                    dismiss()
                    onConfirm(nil)
                }

                PrimaryButton("Confirm") {
                    dismiss()
                    onConfirm(date)
                }
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.bottom, 16)
    }
}
