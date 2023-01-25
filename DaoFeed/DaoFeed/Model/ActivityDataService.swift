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
    var nextPageURL: String? = ""
    static let data = ActivityDataService()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        getEvents(withFilter: .all)
    }
    
    func hasNextPageURL() -> Bool {
        return nextPageURL == nil ? false : true
    }
    
    private func getUrl(filter: FilterType) -> String? {
        var url: String?
        
        switch filter {
        case .discussion:
            self.events = []
            url = "https://gist.githubusercontent.com/JennyShalai/a0485a75242dfdc884ee5cb73a335724/raw/4134fd741c095adb381d53f49612c3c9f363ca39/ActivityEventsFilteredDiscussions.json"
        case .vote:
            self.events = []
            url = "https://gist.githubusercontent.com/JennyShalai/bcddda13fa164e620de4d9a4ca4d70c4/raw/d9c1fae17ed11b241d6db53d71b8253de8e9c118/ActivityEventsFilteredVotes.json"
        case .all:
            if nextPageURL == "" {
                url = "https://gist.githubusercontent.com/JennyShalai/f835cece125e6bbb241edc99d8938ac2/raw/8fd73d2ff6ee6479aa0ef66ea1cf1e7141f4e43d/ActivityEventsPage1.json"
            }
            if nextPageURL != "" && nextPageURL != nil {
                url = nextPageURL!
            }
        }
        return url
    }
    
    func getEvents(withFilter filter: FilterType) {
        
        guard let urlGist = getUrl(filter: filter) else { return }
        guard let url = URL(string: urlGist) else { return }
        
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
}

fileprivate struct ResponceDataForActivityEvents: Decodable {
    
    let next: String?
    let result: [ActivityEvent]
}

