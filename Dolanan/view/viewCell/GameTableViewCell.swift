//
//  GameTableViewCell.swift
//  Dolanan
//
//  Created by Tio on 23/02/23.
//

import UIKit
import Kingfisher

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivGameLogo: UIImageView!
    @IBOutlet weak var labelGameName: UILabel!
    @IBOutlet weak var labelGameGenre: UILabel!
    @IBOutlet weak var labelGameRating: UILabel!
    @IBOutlet weak var labelGameRatingCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        ivGameLogo.addoverlay(alpha: 0.5)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    func setupData(game: Game){
        ivGameLogo.setKfImage(url: game.gamePosterUrl)
        labelGameName.text = game.name
        labelGameRating.text = game.gameRatingText
        labelGameGenre.text = game.genre
        labelGameRatingCount.text = game.gameRatingCount
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
