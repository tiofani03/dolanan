//
//  GameResponse.swift
//  Dolanan
//
//  Created by Tio on 22/02/23.
//

import Foundation

struct GameApiResponse: Codable {
    
    let count: Int
    let results: [GameResponse]
    
    enum CodingKeys: String, CodingKey {
        case count
        case results
    }
}
