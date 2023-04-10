//
//  ActivityDataService.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI
import Combine

class ActivityDataService: ObservableObject {
    @Published var events: [ActivityEvent] = []
    private var nextPageURL: URL?
    private var cancellables = Set<AnyCancellable>()
    
    init(filter: FilterType = .all) {
        getEvents(withFilter: filter, fromStart: true)
    }
    
    func hasNextPageURL() -> Bool {
        return nextPageURL == nil ? false : true
    }
    
    func getEvents(withFilter filter: FilterType, fromStart: Bool) {
        if fromStart {
            nextPageURL = nil
            events = []
        }

        let url = getUrl(filter: filter)

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
    
    private func getUrl(filter: FilterType) -> URL {
        if nextPageURL != nil {
            return nextPageURL!
        }

        switch filter {
        case .treasury:
            return URL(string: "https://gist.githubusercontent.com/JennyShalai/a0485a75242dfdc884ee5cb73a335724/raw/12445d11757ca95b2706661f759fa84f93953439/ActivityEventsFilteredDiscussions.json")!
        case .vote:
            return URL(string: "https://gist.githubusercontent.com/JennyShalai/bcddda13fa164e620de4d9a4ca4d70c4/raw/b8af409985fc4ad24ea6c375086a1f0479c5f8d9/ActivityEventsFilteredVotes.json")!
        case .all:
            return URL(string: "https://gist.githubusercontent.com/JennyShalai/f835cece125e6bbb241edc99d8938ac2/raw/8aebe2f922b3b24e23934867fc67f8b4f3948917/ActivityEventsPage1.json")!
        }
    }
}

fileprivate struct ResponceDataForActivityEvents: Decodable {
    let next: URL?
    let result: [ActivityEvent]
}

