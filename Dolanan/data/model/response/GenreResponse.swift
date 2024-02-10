//
//  GenreModel.swift
//  Dolanan
//
//  Created by Tio on 22/02/23.
//

import Foundation

struct GenreResponse: Codable, Identifiable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
