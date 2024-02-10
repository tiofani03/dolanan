//
//  ScreenshotModel.swift
//  Dolanan
//
//  Created by Tio on 25/02/23.
//

import Foundation


struct ScreenshotApiResponse: Codable {
    
    let count: Int
    let results: [ScreenshotResponse]
    
    enum CodingKeys: String, CodingKey {
        case count
        case results
    }
}

struct ScreenshotResponse : Codable, Identifiable {
    let id: Int
    let image: String
}
