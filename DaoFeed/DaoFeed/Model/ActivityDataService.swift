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
        guard let url = URL(string: "https://gist.githubusercontent.com/JennyShalai/f835cece125e6bbb241edc99d8938ac2/raw/ec3d791bd3f9abff71a80f70bf03919338281cad/ActivityEvents.json") else { return }
        
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
            .decode(type: [ActivityEvent].self, decoder: decoder)
            .sink { (completion) in
                print("complition \(completion)")
            } receiveValue: { [weak self] (returnedEvent) in
                self?.events = returnedEvent
                self?.cashedEvents = returnedEvent
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
