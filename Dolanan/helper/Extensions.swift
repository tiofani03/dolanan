//
//  Extensions.swift
//  Dolanan
//
//  Created by Tio on 21/02/23.
//

import Foundation
import UIKit
import Kingfisher

extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension UIView {
    func addoverlay(color: UIColor = .black,alpha : CGFloat = 0.6) {
        let overlay = UIView()
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.frame = bounds
        overlay.backgroundColor = color
        overlay.alpha = alpha
        addSubview(overlay)
    }
}

extension UIColor {
    static var activeTint: UIColor { return "5C65D3".hexToUIColor() }
}


extension UIImageView {
    func setKfImage(url: URL?) {
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 10)
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
    func circleImageView() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
        contentMode = .scaleAspectFill
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = false
        clipsToBounds = true
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func hexToUIColor(alpha: Double = 1.0) -> UIColor {
        var cString = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#"){
            cString.remove(at: cString.startIndex)
        }
        if cString.count != 6 {
            return UIColor.gray
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor (
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat ((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

class Utils{
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
    
    
    static let getLabelColor : String = {
        if #available(iOS 13.0, *) {
            let isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
            return isDarkMode ? "white" : "black"
        } else {
            return "black"
        }
    }()
    
    
    static var apiKey: String {
        get {
            // 1
            guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
                fatalError("Couldn't find file 'Info.plist'.")
            }
            // 2
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_KEY' in 'TMDB-Info.plist'.")
            }
            return value
        }
    }
    
}
