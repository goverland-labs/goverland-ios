//
//  ToastViewModel.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 29.03.23.
//

import Combine
import Foundation

class ToastViewModel: ObservableObject {
    static let shared = ToastViewModel()
    private var timer: Timer?

    @Published var errorMessage: String?

    private init() {}

    func setErrorMessage(_ message: String?) {
        errorMessage = message
        if let message = message {
            // target 200 words per minute reading speed
            let words = message.components(separatedBy: .whitespacesAndNewlines).count
            let seconds = min(5, max(2, Double(words * 60 / 200).rounded(.up)))
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] _ in
                self?.errorMessage = nil
            }
        }
    }
}
