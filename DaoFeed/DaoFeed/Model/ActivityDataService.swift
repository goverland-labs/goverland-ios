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
    private var nextPageURL: String? = "https://gist.githubusercontent.com/JennyShalai/f835cece125e6bbb241edc99d8938ac2/raw/f7fcb47a9fe8a0897d74926e0e1d23b6199e5b05/ActivityEventsPage1.json"
    static let data = ActivityDataService()
    private var cashedEvents: [ActivityEvent] = []
    private var cancellables = Set<AnyCancellable>() // to store publishers
    
    private init() {
        getEvents(withFilter: .all)
        cashedEvents = events
    }
    
    func getEvents(withFilter filter: FilterType) {
        guard let nextPageURL = nextPageURL else { return }
        guard let url = URL(string: nextPageURL) else { return }
        
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
                print("complition \(completion)")
            } receiveValue: { [weak self] (returnedData) in
                self?.events.append(contentsOf: returnedData.result)
                self?.cashedEvents.append(contentsOf: returnedData.result)
                self?.nextPageURL = returnedData.next
                self?.filterCashedEvents(withFilter: filter)
            }
            .store(in: &cancellables)
            
    }
    
    func filterCashedEvents(withFilter filter: FilterType) {
        switch filter {
        case .discussion:
            self.events = cashedEvents.filter { $0.type == .discussion }
        case .vote:
            self.events = cashedEvents.filter { $0.type == .vote }
        case .all:
            self.events = cashedEvents
        }
    }
}

fileprivate struct ResponceDataForActivityEvents: Decodable {
    
    let next: String
    let result: [ActivityEvent]
}
