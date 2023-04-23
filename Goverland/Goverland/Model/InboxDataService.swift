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
    private var nextPageURL: URL?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getEvents(fromStart: true)
    }
    
    func hasNextPageURL() -> Bool {
        return nextPageURL == nil ? false : true
    }
    
    func getEvents(fromStart: Bool) {
        if fromStart {
            nextPageURL = nil
            events = []
        }

        let url = getUrl()

        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        URLSession
            .shared
            .dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: ResponceDataForInboxEvents.self, decoder: decoder)
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
        return URL(string: "https://gist.githubusercontent.com/JennyShalai/f835cece125e6bbb241edc99d8938ac2/raw/8aebe2f922b3b24e23934867fc67f8b4f3948917/ActivityEventsPage1.json")!
    }
}

fileprivate struct ResponceDataForInboxEvents: Decodable {
    let next: URL?
    let result: [InboxEvent]
}

