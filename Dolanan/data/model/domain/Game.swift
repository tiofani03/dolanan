//
//  Game.swift
//  Dolanan
//
//  Created by Tio on 01/03/23.
//

import Foundation


struct Game {
    let id: Int
    let name: String
    let description: String
    let backgroundImage: String
    let ratingTotal: Double
    let ratingCount: Int
    let genre: String
    
    var gamePosterUrl: URL? {
        return URL(string: backgroundImage)
    }
    
    var gameRatingText: String {
        let rating = (ratingTotal * 2)
        return String(rating)
    }
    
    var gameRatingCount: String {
        return "(\(ratingCount) Reviews)"
    }
}

extension Game {
    init(game: GameResponse) {
        self.id = game.id ?? 0
        self.name = game.gameNameText
        self.description = game.description ?? ""
        self.backgroundImage = game.backgroundImage ?? ""
        self.ratingTotal = game.ratingTotal ?? 0.0
        self.ratingCount = game.ratingCount ?? 0
        self.genre = game.gameGenreText
    }
}
