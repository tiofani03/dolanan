//
//  NetworkManager.swift
//  Dolanan
//
//  Created by Tio on 22/02/23.
//

import Foundation
import Alamofire

class NetworkManager {
    
    let jsonDecoder = JSONDecoder()
    private let baseUrl = "https://api.rawg.io/api/"
    let apiKeyParameter: Parameters = ["key": Utils.apiKey]
    
    func getGameList(
        searchQuery: String = "" ,
        completion: @escaping(Swift.Result<GameApiResponse, GameError>) -> Void) {
            let parameters: Parameters = [
                "key": Utils.apiKey,
                "search": searchQuery
            ]
            AF.request(
                baseUrl + "games",
                method: .get,
                parameters: parameters
            ).responseDecodable (of: GameApiResponse.self) { rawJson in
                switch rawJson.result{
                case .failure : completion(.failure(.apiError))
                case .success(let data):
                    completion(.success(data))
                    
                }
            }
        }
    
    func getGameDetail(id: Int, completion: @escaping (Swift.Result<GameResponse, GameError>) -> Void) {
        AF.request(
            baseUrl + "games/\(id)",
            method: .get,
            parameters: apiKeyParameter
        ).responseDecodable(of: GameResponse.self){ rawJson in
            switch rawJson.result{
            case .failure: completion(.failure(.apiError))
            case .success(let data): completion(.success(data))
            }
        }
    }
    
    func getGameScreenshots(id: Int, completion: @escaping (Swift.Result<ScreenshotApiResponse, GameError>) -> Void){
        AF.request(
            baseUrl + "games/\(id)/screenshots",
            method: .get,
            parameters: apiKeyParameter
        ).responseDecodable(of: ScreenshotApiResponse.self){ rawJson in
            switch rawJson.result{
            case .failure: completion(.failure(.apiError))
            case .success(let data): completion(.success(data))
            }
        }
    }
}


