//
//  DaoDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.05.23.
//

import Foundation
import Combine

class DaoDataSource: ObservableObject {
    @Published var daos: [Dao] = []

    private var total: Int?
    private var page: Int?
    private var cancellables = Set<AnyCancellable>()

    func loadData(category: DaoCategory) {
        APIService.daos(category: category)
            .sink { errorCompletion in
                // do nothing
            } receiveValue: { (daos, headers) in
                self.daos = daos
                self.total = headers["x-total-count"] as? Int
            }
            .store(in: &cancellables)
    }
}
