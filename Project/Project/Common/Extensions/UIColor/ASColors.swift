//
//  ASColors.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation
import UIKit

// MARK: - UIColor representation of custom colors
extension UIColor {
    
    /// Circle Color One
    static let circleOne = UIColor.init(hexString: "#D35400")
    
    /// Circle Color Two
    static let circleTwo = UIColor.init(hexString: "#f48fb1")
    
    /// Circle three
    static let circleThree = UIColor.init(hexString: "#58D68D")
    
    /// Circle Four
    static let circleFour = UIColor.init(hexString: "#f1bc00")
    
    /// Circle Five
    static let circleFive = UIColor.init(hexString: "#A569BD")
    
    /// Circle Six
    static let circleSix = UIColor.init(hexString: "#3498DB")
    
    /// Circle Seven
    static let circleSeven = UIColor.init(hexString: "#0E97F5")
    
    // MARK:-
    // MARK: Character Color
    // MARK:
    
    /// This function is used to assign diffrent background color to button or lable according to character
    ///
    /// - Parameter char: Pass the first character
    /// - Returns: this will return the UIColor for every character
    class func with(char: String) -> UIColor {
        let arrColors: [UIColor] = [.circleOne, .circleTwo, .circleThree, .circleFour, .circleFive, .circleSix]
        let arrAlpha = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        let position = arrAlpha.firstIndex(of: char.uppercased())
        if position != nil {
            let reminder = position! % arrColors.count
            if arrColors.count  > reminder {
                return arrColors[reminder]
            }
        }
        
        return .circleOne
    }
}

//MARK:- HEX CONVERSION
extension UIColor {
    
    /// Hex string conversion for color
    /// - Parameter hexString: String
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    /// Convert string to color
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format: "#%06x", rgb) as String
    }
}
