//
//  ProfileViewController.swift
//  Dolanan
//
//  Created by Tio on 21/02/23.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var ivProfile: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivProfile.kf.setImage(with: URL(string: "https://gitlab.com/uploads/-/system/user/avatar/5789163/avatar.png?width=400"))
        ivProfile.circleImageView()
    }
    
}
