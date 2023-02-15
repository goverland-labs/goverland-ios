//
//  SelectDAOsDataService.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-02-02.
//

import SwiftUI
import Combine

class DaoDataService: ObservableObject {
    
    @Published var daosGroups: [DaoGroup] = []
    static let data = DaoDataService()
    private var cancellables = Set<AnyCancellable>()
    private var paginationStorage: [DaoGroupType: URL?] = [:]
    
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
        return paginationStorage[groupType] == nil ? false : true
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
                   self?.daosGroups.append(DaoGroup.init(id: UUID(), groupType: data.daosGroup, daos: data.daos))
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
            .decode(type: DaoGroup.self, decoder: decoder)
            .sink { (completion) in
                print(completion)
            } receiveValue: { [weak self] (returnedData) in
                print(returnedData)
//               for data in returnedData {
//                   self?.paginationStorage[data.daosGroup] = data.next
//                   self?.daosGroups.append(DaoGroup.init(id: UUID(), groupType: data.daosGroup, daos: data.daos))
//                }
            }
            .store(in: &cancellables)
    }
}

fileprivate struct ResponceDataForSelectDao: Decodable {
    let daosGroup: DaoGroupType
    let next: URL?
    let daos: [Dao]
}
