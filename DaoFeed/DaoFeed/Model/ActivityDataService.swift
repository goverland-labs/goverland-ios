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
    private var nextPageURL: String? = "https://gist.githubusercontent.com/JennyShalai/f835cece125e6bbb241edc99d8938ac2/raw/35a88a34e457eda8b26c58b23a1b5f9c5aa4eb46/ActivityEventsPage1.json"
    static let data = ActivityDataService()
    private var cancellables = Set<AnyCancellable>() // to store publishers
    
    private init() {
        getEvents(withFilter: .all)
    }
    
    func isNextPageURL() -> Bool {
        return nextPageURL == "nil" ? false : true
    }
    
    func getEvents(withFilter filter: FilterType) {
        
        var urlGist: String = ""
        
        switch filter {
        case .discussion:
            urlGist = "https://gist.githubusercontent.com/JennyShalai/a0485a75242dfdc884ee5cb73a335724/raw/2f82baa0a88735241ee79cf551f90d45c5d1972a/ActivityEventsFilteredDiscussions.json"
        case .vote:
            urlGist = "https://gist.githubusercontent.com/JennyShalai/bcddda13fa164e620de4d9a4ca4d70c4/raw/517fe666d627d2480eed86371219eb1d9e3e8a6c/ActivityEventsFilteredDiscussions.json"
        case .all:
            guard let nextPageURL = nextPageURL else { return }
            urlGist = nextPageURL
        }
        
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
                self?.events = returnedData.result
                self?.nextPageURL = returnedData.next
            }
            .store(in: &cancellables)
    }
}

fileprivate struct ResponceDataForActivityEvents: Decodable {
    
    let next: String
    let result: [ActivityEvent]
}
