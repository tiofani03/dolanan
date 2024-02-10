//
//  MainViewModel.swift
//  Dolanan
//
//  Created by Tio on 22/02/23.
//

import Foundation

class MainViewModel{
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getGameList(query: String = "",completion: @escaping (Result<[Game], GameError>) -> Void) {
        self.networkManager.getGameList(searchQuery: query) { (result) in
            switch result {
            case .success(let response):
                var games: [Game] = []
                for result in response.results {
                    let game = Game(game: result)
                    games.append(game)
                }
                completion(.success(games))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
