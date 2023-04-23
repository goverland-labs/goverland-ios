//
//  TreasuryDataService.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-04-23.
//

import SwiftUI
import Combine

class TreasuryDataService: ObservableObject {
    @Published var events: [TreasuryEvent] = []
    private var nextPageURL: URL?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getEvents()
    }
    
    func hasNextPageURL() -> Bool {
        return nextPageURL == nil ? false : true
    }
    
    func getEvents() {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        URLSession
            .shared
            .dataTaskPublisher(for: getUrl())
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: ResponceDataForTreasuryEvents.self, decoder: decoder)
            .sink { (completion) in
            } receiveValue: { [weak self] (returnedData) in
                self?.events.append(contentsOf: returnedData.result)
                self?.nextPageURL = returnedData.next
            }
            .store(in: &cancellables)
    }
    
    private func getUrl() -> URL {
        if nextPageURL != nil {
            return nextPageURL!
        }
        
        return URL(string: "https://gist.githubusercontent.com/JennyShalai/56c1e762d7090a66df9a5a4dbbf2d101/raw/4b75cdbc9fc095647042053d06b60e270a39631c/TreasuryEvents.json")!
    }
}

fileprivate struct ResponceDataForTreasuryEvents: Decodable {
    let next: URL?
    let result: [TreasuryEvent]
}

