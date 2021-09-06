//
//  UIColorExtension.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 02/09/2021.
//

import UIKit

extension UIColor {
    
    static var rssGradient1 = UIColor().hexStringToUIColor(hex: "#ec9f05")
    static var rssGrafient2 = UIColor().hexStringToUIColor(hex: "#ff4e00")
    
    // Source: https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values/24263296
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
