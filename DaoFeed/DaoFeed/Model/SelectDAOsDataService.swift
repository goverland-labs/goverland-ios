//
//  SelectDAOsDataService.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-02-02.
//

import SwiftUI
import Combine

class SelectDAOsDataService: ObservableObject {
    
    @Published var daosGroups: [DAOsGroup] = []
    static let data = SelectDAOsDataService()
    private var nextPageURL: URL?
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        getDAOs(fromStart: true)
    }
    
    private func getUrl() -> URL {
        if nextPageURL != nil {
            return nextPageURL!
        }
        return URL(string: "https://gist.githubusercontent.com/JennyShalai/03105079e34e3821069dd0a98b58e223/raw/1c020ef19de9b4cea21eceee6c697a128686f2ef/SelectDAO.js")!
    }
    
    func getDAOs(fromStart: Bool) {
        if fromStart {
            nextPageURL = nil
            daosGroups = []
        }

        let decoder = JSONDecoder()
        
        URLSession
            .shared
            .dataTaskPublisher(for: getUrl())
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: [ResponceDataForSelectDAOs].self, decoder: decoder)
            .sink { (completion) in
            } receiveValue: { [weak self] (returnedData) in
               for data in returnedData {
                   self?.daosGroups.append(DAOsGroup.init(id: UUID(), groupType: data.daosGroup, daos: data.daos))
                }
            }
            .store(in: &cancellables)
    }
    
}

fileprivate struct ResponceDataForSelectDAOs: Decodable {
    let daosGroup: daosGroupType
    let next: URL?
    let daos: [DAO]
}
