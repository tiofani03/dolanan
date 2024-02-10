//
//  Game.swift
//  Dolanan
//
//  Created by Tio on 21/02/23.
//

import Foundation

struct GameResponse: Codable, Identifiable{
    let id: Int?
    let name: String?
    let description: String?
    let released: String?
    let backgroundImage: String?
    let ratingTotal: Double?
    let ratingCount: Int?
    let desc: String?
    
    let genres: [GenreResponse]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description = "description_raw"
        case released
        case backgroundImage = "background_image"
        case ratingTotal = "rating"
        case ratingCount = "ratings_count"
        case genres
        case desc = "description"
    }
    
    static private let dateTextFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    var gameNameText: String {
        guard let releaseDate = self.released, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return self.name ?? "n/a"
        }
        return updateGameTitle(self.name ?? "", year: GameResponse.dateTextFormatter.string(from: date))
    }
    
    var gameGenreText: String {
        var genre = [String]()
        if genres != nil {for i in genres! { genre.append(i.name) }}
        return genre.joined(separator: ", ")
    }
    
    func updateGameTitle(_ title: String, year: String) -> String {
        let regex = try! NSRegularExpression(pattern: "\\((\\d{4})\\)$")
        let range = NSRange(location: 0, length: title.utf16.count)
        
        if regex.firstMatch(in: title, options: [], range: range) != nil {
            return title
        } else {
            return "\(title) (\(year))"
        }
    }
    
}
