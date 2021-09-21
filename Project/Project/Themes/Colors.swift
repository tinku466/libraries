//
//  Colors.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation
import UIKit

///
///USAGE
///

/// Create an enum to handle each and every colour required in our application.
enum Color {
    
    /// TextField Background Color 'F7F7F7'
    static let textFieldBGColor = UIColor.init(named: "colorTextFieldBG") ?? .lightGray

    /// Textfield active color '282828'
    static let textFieldActiveColor = UIColor.init(named: "colorTextFieldActive") ?? .black
    
    /// Textfield active color '3C3C3C'
    static let border = UIColor.init(named: "colorBorder") ?? .black
    
    /// Dark color '282828'
    static let darkText = UIColor.init(named: "colorTextFieldActive") ?? .black
    
    /// Dark color '354F30'
    static let darkGreen = UIColor.init(named: "colorDarkGreen") ?? .green
    
    /// Dark color 'A9CC4A'
    static let lightGreen = UIColor.init(named: "colorLightGreen") ?? .green
    
    /// Dark color 'F87744'
    static let orange = UIColor.init(named: "colorOrange") ?? .orange
    
    /// Textfield error color 'D01024'
    static let errorColor = Color.custom(hexString: "#D01024", alpha: 1.0).value
    
    ///  red color 'D21632'
    static let darkRedColor = UIColor.init(named: "colorDarkRed") ?? Color.custom(hexString: "#D21632", alpha: 1.0).value
    
    ////
    /// CASE STARTS FROM HERE
    
    /// custom(hexString: String, alpha: Double) to get UIColor values other than the previous ones.
    case custom(hexString: String, alpha: Double)
    
    /// withAlpha(_ alpha: Double) to get UIColor values with opacity.
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

/// Put the values (hex string or RGB literal) to the following extension of Color enum
extension Color {
    
    /// Color from hex
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        switch self {
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
        }
        return instanceColor
    }
}
