//
//  GameEnum.swift
//  Dolanan
//
//  Created by Tio on 22/02/23.
//

import Foundation

enum GameError: Error, CustomNSError {
    case networkError
    case apiError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data from internet"
        case .networkError: return "No internet connection"
        }
    }
}
