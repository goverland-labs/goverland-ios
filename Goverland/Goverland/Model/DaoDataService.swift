//
//  SelectDAOsDataService.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-02.
//

import SwiftUI
import Combine

class DaoDataService: ObservableObject {
    
    @Published var daoGroups: [DaoGroupType: [Dao]] = [:]
    static let data = DaoDataService()
    private var cancellables = Set<AnyCancellable>()
    private var paginationStorage: [DaoGroupType: URL?] = [:]
    var keys: [DaoGroupType] {
        daoGroups.keys.sorted { $0.sortingNumber < $1.sortingNumber }
    }
    
    private init() {
        getInitialDaos()
    }
    
    private func getUrl() -> URL {
        return URL(string: "https://gist.githubusercontent.com/JennyShalai/03105079e34e3821069dd0a98b58e223/raw/2ccfa98857767607758b7f69adf5da3a65b77c1d/SelectDAO.js")!
    }
    
    private func getNextUrl(forGroupType groupType: DaoGroupType) -> URL? {
        if let nextURL = paginationStorage[groupType] {
            return nextURL
        }
        return nil
    }
    
    func hasNextPageURL(forGroupType groupType: DaoGroupType) -> Bool {
        if let nextPage = paginationStorage[groupType] {
            return nextPage == nil ? false : true
        }
        return false
    }
    
    func getInitialDaos() {
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
                   self?.paginationStorage[data.daosGroup] = data.next
                   self?.daoGroups[data.daosGroup] = data.daos
                }
            }
            .store(in: &cancellables)
    }
    
    func getMoreDaos(inGroup group: DaoGroupType) {
        let decoder = JSONDecoder()
        guard let nextURl = getNextUrl(forGroupType: group) else { return }
        
        URLSession
            .shared
            .dataTaskPublisher(for: nextURl)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: ResponceDataForSelectDao.self, decoder: decoder)
            .sink { (completion) in
            } receiveValue: { [weak self] (returnedData) in
                self?.paginationStorage[returnedData.daosGroup] = returnedData.next
                self?.daoGroups[returnedData.daosGroup]!.append(contentsOf: returnedData.daos)
            }
            .store(in: &cancellables)
    }
}

fileprivate struct ResponceDataForSelectDao: Decodable {
    let daosGroup: DaoGroupType
    let next: URL?
    let daos: [Dao]
}

