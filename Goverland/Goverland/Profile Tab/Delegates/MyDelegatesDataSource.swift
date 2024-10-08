//
//  MyDelegatesDataSource.swift
//  Goverland
//
//  Created by Jenny Shalai on 2024-10-08.
//  Copyright © Goverland Inc. All rights reserved.
//
	

import Foundation

class MyDelegatesDataSource: ObservableObject {
    @Published var delegates: [Int] = []
    
    static let shared = MyDelegatesDataSource()
    
    func refresh() {
    }
}
