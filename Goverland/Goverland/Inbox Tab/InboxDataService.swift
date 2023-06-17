//
//  InboxDataService.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI
import Combine

class InboxDataService: ObservableObject {
    @Published var events: [InboxEvent] = []
    @Published var failedToLoadInitialData = false
    @Published var failedToLoadMore = false
    private var cancellables = Set<AnyCancellable>()

    private(set) var total: Int?

    func refresh(withFilter filter: FilterType) {
        events = []
        failedToLoadInitialData = false
        failedToLoadMore = false

        loadInitialData(filter: .all)
    }

    private func loadInitialData(filter: FilterType) {

    }
}
    
//    func getEvents(withFilter filter: FilterType, fromStart: Bool) {
//        isLoadingData = true
//        if fromStart {
//            nextPageURL = nil
//            events = []
//        }
//
//        let url = getUrl(filter: filter)
//
//        let decoder = JSONDecoder()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
//        decoder.dateDecodingStrategy = .formatted(dateFormatter)
//
//        URLSession
//            .shared
//            .dataTaskPublisher(for: url)
//            .subscribe(on: DispatchQueue.global(qos: .background))
//            .receive(on: DispatchQueue.main)
//            .map(\.data)
//            .decode(type: ResponceDataForInboxEvents.self, decoder: decoder)
//            .catch { (error) -> Just<ResponceDataForInboxEvents> in
//                    print("Decoding error: \(error)")
//                    return Just(ResponceDataForInboxEvents(next: nil, result: []))
//                }
//            .sink { (completion) in
//            } receiveValue: { [weak self] (returnedData) in
//                self?.events.append(contentsOf: returnedData.result)
//                self?.nextPageURL = returnedData.next
//                self?.isLoadingData = false
//            }
//            .store(in: &cancellables)
//    }
//
//    private func getUrl(filter: FilterType) -> URL {
//        if nextPageURL != nil {
//            return nextPageURL!
//        }
//        switch filter {
//        case .all:
//            return URL(string: "https://gist.githubusercontent.com/sche/8a521a698dc73affc1f04c4e21d48572/raw/371ecea3fd5b6bbf541b8a779e5f42e9230601b0/votes1.json")!
//        case .vote:
//            return URL(string: "https://gist.githubusercontent.com/sche/584a6dad637c237f209327155de18b00/raw/8126415c7a716b6607b2991430f6a43b08b36feb/votes2.json")!
//        case .treasury:
//            return URL(string: "https://gist.githubusercontent.com/sche/8734cca923505a4236130754dfec3d09/raw/bb8fea49c535a55bfe4bd02e8b2235299d963cd0/treasury.json")!
//        }
//    }
//}
//
//fileprivate struct ResponceDataForInboxEvents: Decodable {
//    let next: URL?
//    let result: [InboxEvent]
//}
