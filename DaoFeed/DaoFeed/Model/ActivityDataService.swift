//
//  ActivityDataService.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI
import Combine

class ActivityDataService: ObservableObject {
    
    @Published var events: [ActivityEvent] = []
    static let data = ActivityDataService()
    private var nextPageURL: URL?
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        getEvents(withFilter: .all)
    }
    
    func hasNextPageURL() -> Bool {
        return nextPageURL == nil ? false : true
    }
    
    func getEvents(withFilter filter: FilterType) {
        
        guard let url = getUrl(filter: filter) else { return }
        
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
            .decode(type: ResponceDataForActivityEvents.self, decoder: decoder)
            .sink { (completion) in
            } receiveValue: { [weak self] (returnedData) in
                self?.events.append(contentsOf: returnedData.result)
                self?.nextPageURL = returnedData.next
            }
            .store(in: &cancellables)
    }
    
    private func getUrl(filter: FilterType) -> URL? {
        var url: URL?

        if nextPageURL != nil {
            return nextPageURL!
        }

        switch filter {
        case .discussion:
            self.events = []
            url = URL(string: "https://gist.githubusercontent.com/JennyShalai/a0485a75242dfdc884ee5cb73a335724/raw/4134fd741c095adb381d53f49612c3c9f363ca39/ActivityEventsFilteredDiscussions.json")
        case .vote:
            self.events = []
            url = URL(string: "https://gist.githubusercontent.com/JennyShalai/bcddda13fa164e620de4d9a4ca4d70c4/raw/d9c1fae17ed11b241d6db53d71b8253de8e9c118/ActivityEventsFilteredVotes.json")
        case .all:
            url = URL(string: "https://gist.githubusercontent.com/JennyShalai/f835cece125e6bbb241edc99d8938ac2/raw/16082a942ad530f37c8d300cb8c26c782df28ed1/ActivityEventsPage1.json")
        }
        return url
    }
    
    func reset() {
        nextPageURL = nil
        events = []
    }
}

fileprivate struct ResponceDataForActivityEvents: Decodable {
    
    let next: URL?
    let result: [ActivityEvent]
}

