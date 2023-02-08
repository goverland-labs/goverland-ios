//
//  SelectDAOsDataService.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-02-02.
//

import SwiftUI
import Combine

class DaoDataService: ObservableObject {
    
    @Published var daosGroups: [DaoGroup] = []
    static let data = DaoDataService()
    private var nextPageURL: URL?
    private var cancellables = Set<AnyCancellable>()
    private var allDao: [Dao] = []
    
    private init() {
        getDaos(fromStart: true)
    }
    
    private func getUrl() -> URL {
        if nextPageURL != nil {
            return nextPageURL!
        }
        return URL(string: "https://gist.githubusercontent.com/JennyShalai/03105079e34e3821069dd0a98b58e223/raw/1c020ef19de9b4cea21eceee6c697a128686f2ef/SelectDAO.js")!
    }
    
    func getDaos(fromStart: Bool) {
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
            .decode(type: [ResponceDataForSelectDao].self, decoder: decoder)
            .sink { (completion) in
            } receiveValue: { [weak self] (returnedData) in
               for data in returnedData {
                   self?.daosGroups.append(DaoGroup.init(id: UUID(), groupType: data.daosGroup, daos: data.daos))
                   for dao in data.daos {
                       self?.allDao.append(dao)
                   }
                }
            }
            .store(in: &cancellables)
    }
    
    func getFilteredDao(text: String) -> [Dao] {
        return text.isEmpty ? allDao : allDao.filter { $0.name.localizedCaseInsensitiveContains(text)}
    }
    
}

fileprivate struct ResponceDataForSelectDao: Decodable {
    let daosGroup: DaoGroupType
    let next: URL?
    let daos: [Dao]
}
