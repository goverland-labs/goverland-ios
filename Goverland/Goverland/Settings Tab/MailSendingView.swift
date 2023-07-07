//
//  MailSendingView.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-03-04.
//

import SwiftUI
import UIKit
import MessageUI

struct MailSettingView: View {
    @State private var isShowingMailView = false
    @State private var isShowingMailAlertView = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    var body: some View {
        HStack {
            Image("email")
                .foregroundColor(.primary)
                .frame(width: 30)
            Button("Email", action: {
                if !MFMailComposeViewController.canSendMail() {
                    isShowingMailAlertView.toggle()
                } else {
                    isShowingMailView.toggle()
                }
                Tracker.track(.settingsOpenEmail)
            })
            .sheet(isPresented: $isShowingMailView) {
                MailSendingView(result: $result)
            }
            .alert(isPresented: $isShowingMailAlertView,
                   content: getSettingsEmailAddressAlert)
            
            Spacer()
            Image(systemName: "arrow.up.right")
                .foregroundColor(.textWhite40)
            
        }
        .accentColor(.textWhite)
    }
    
    private func getSettingsEmailAddressAlert() -> Alert {
        Alert(
            title: Text("Our email address:"),
            message: Text("contact@goverland.xyz"),
            primaryButton: .default(Text("Copy"), action: {
                UIPasteboard.general.string = "contact@goverland.xyz"
            }),
            secondaryButton: .cancel()
        )
    }
}

fileprivate struct MailSendingView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailSendingView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["contact@goverland.xyz"])
        vc.setSubject("Email from Goverland App")
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailSendingView>) {

    }
}
