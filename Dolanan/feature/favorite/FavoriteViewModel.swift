//
//  FavoriteViewModel.swift
//  Dolanan
//
//  Created by Tio on 01/03/23.
//

import Foundation

class FavoriteViewModel {
    private let favoriteProvider: FavoriteProvider
    
    init(favoriteProvider: FavoriteProvider = FavoriteProvider()) {
        self.favoriteProvider = favoriteProvider
    }
    
    func getFavoriteGames(completion: @escaping([Game]) -> Void){
        favoriteProvider.getAllFavoriteGame() { (game) in
            completion(game)
        }
    }
}
