//
//  DetailViewModel.swift
//  Dolanan
//
//  Created by Tio on 24/02/23.
//

import Foundation

class DetailViewModel{
    private let networkManager: NetworkManager
    private let favoriteProvider: FavoriteProvider
    
    init(networkManager: NetworkManager = NetworkManager(), favoriteProvider: FavoriteProvider = FavoriteProvider()){
        self.networkManager = networkManager
        self.favoriteProvider = favoriteProvider
    }
    
    func getGameDetail(id: Int,completion: @escaping (Result<Game, GameError>) -> Void){
        self.networkManager.getGameDetail(id:id) { (result) in
            switch result {
            case .success(let response): completion(.success(Game(game: response)))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func getGameScreenshots(id: Int, completion: @escaping(Result<[ScreenshotResponse], GameError>) -> Void){
        self.networkManager.getGameScreenshots(id: id) { (result) in
            switch result{
            case .success(let response): completion(.success(response.results))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func isGameFavorite(_ id: Int, completion: @escaping(_ isFavorite: Bool) -> Void){
        favoriteProvider.isGameFavorite(id){ (isGameFavorite) in
            completion(isGameFavorite)
        }
        
    }
    
    func addToFavorite(_ game: Game,completion: @escaping() -> Void) {
        favoriteProvider.addToFavorite(game) {
            completion()
        }
    }
    
    func removeFromFavorite(_ id: Int, completion: @escaping() -> Void) {
        favoriteProvider.removeFromFavorite(id){
            completion()
        }
    }
}
