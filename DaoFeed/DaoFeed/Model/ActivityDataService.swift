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
    private var cashedEvents: [ActivityEvent] = []
    private var cancellables = Set<AnyCancellable>() // to store publishers
    
    private init() {
        getEvents(withFilter: .all)
        cashedEvents = events
    }
    
    func getEvents(withFilter filter: FilterType) {
        print("getEvents() started")
        guard let url = URL(string: "https://gist.githubusercontent.com/JennyShalai/f835cece125e6bbb241edc99d8938ac2/raw/0eb37b5bb465151c00e07bc5597ba4e179712ee4/ActivityEvents.json") else { return }
        
        URLSession
            .shared
            .dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: [ActivityEvent].self, decoder: JSONDecoder())
            .sink { (complition) in
                print("complition is : \(complition)")
            } receiveValue: { [weak self] (returnedEvent) in
                self?.events.removeAll()
                self?.cashedEvents.removeAll()
                self?.events = returnedEvent
                self?.cashedEvents = returnedEvent
                self?.filteredActivityEvents(withFilter: filter)
            }
            .store(in: &cancellables)
    }
    
    func filteredActivityEvents(withFilter filter: FilterType) {
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
