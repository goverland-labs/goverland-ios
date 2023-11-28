//
//  EcosystemChart.swift
//  Goverland
//
//  Created by Jenny Shalai on 2023-11-12.
//  Copyright © Goverland Inc. All rights reserved.
//
	

struct EcosystemChart: Decodable {
    let daos: EcosystemChartData
    let proposals: EcosystemChartData
    let voters: EcosystemChartData
    let votes: EcosystemChartData
    
    struct EcosystemChartData: Decodable {
        let current: Int
        let previous: Int
    }
}
