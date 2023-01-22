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
    private var nextPageURL: String = ""
    static let data = ActivityDataService()
    private var cashedEvents: [ActivityEvent] = []
    private var cancellables = Set<AnyCancellable>() // to store publishers
    
    private init() {
        getEvents(withFilter: .all)
        cashedEvents = events
    }
    
    func getEvents(withFilter filter: FilterType) {
        guard let url = URL(string: "https://gist.githubusercontent.com/JennyShalai/d4a0e971dfda1076a487eac509bc9bc7/raw/b68e6de887a7ba1961ee229d28ce0b346d6fc2e3/ActivityEventsPage2.json") else { return }
        
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
                self?.events = returnedData.result
                self?.cashedEvents = returnedData.result
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
    
    init(next: String, result: [ActivityEvent]) {
        self.next = next
        self.result = result
    }
    
}
