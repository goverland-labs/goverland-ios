//
//  DaoInfoEventsDataSource.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 10.07.23.
//

import Foundation
import Combine

class DaoInfoEventsDataSource: InboxDataSource {
    let daoID: UUID

    init(daoID: UUID) {
        self.daoID = daoID
        super.init()
    }

    override var initialLoadingPublisher: AnyPublisher<([InboxEvent], HttpHeaders), APIError> {
        APIService.daoEvents(daoID: daoID)
    }
    override var loadMorePublisher: AnyPublisher<([InboxEvent], HttpHeaders), APIError> {
        APIService.daoEvents(daoID: daoID, offset: events?.count ?? 0)
    }

    override func storeUnreadEventsCount(headers: HttpHeaders) {}
}
