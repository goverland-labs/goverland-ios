//
//  DaoTermsAgreement.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 01.02.24.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation
import SwiftData

@Model
/// Model to store User agreements with DAO terms when voting.
final class DaoTermsAgreement {
    @Attribute(.unique) private(set) var daoId: UUID
    private(set) var confirmationDate: Date

    init(daoId: UUID, confirmationDate: Date) {
        self.daoId = daoId
        self.confirmationDate = confirmationDate
    }
}

extension DaoTermsAgreement {
    @MainActor
    static func upsert(dao: Dao) throws -> DaoTermsAgreement {
        let id = dao.id
        let fetchDescriptor = FetchDescriptor<DaoTermsAgreement>(
            predicate: #Predicate { $0.daoId == id }
        )
        let context = appContainer.mainContext
        if let agreement = try context.fetch(fetchDescriptor).first {
            logInfo("[DaoTermsAgreement] Update existing agreement for \(dao.name).")
            agreement.daoId = dao.id
            agreement.confirmationDate = Date()
            try context.save()
            return agreement
        }
        logInfo("[UserProfile] Create terms agreement for \(dao.name).")
        let agreement = DaoTermsAgreement(daoId: dao.id, confirmationDate: Date())
        context.insert(agreement)
        try context.save()
        return agreement
    }
}
