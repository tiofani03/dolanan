//
//  ScreenshotsCollectionViewCell.swift
//  Dolanan
//
//  Created by Tio on 25/02/23.
//

import UIKit
import Kingfisher

class ScreenshotsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ivGameScreenshot: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    func setImage(url: URL?) {
        ivGameScreenshot.setKfImage(url: url)
    }
}
