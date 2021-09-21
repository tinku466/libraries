//
//  Fonts.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation
import UIKit

/// Fonts
struct Font {
    // Usage Examples
    
    /// Tab Bar Title
    static let tabBarTitle = Font(.installed(.robotoMedium), size: .standard(.h5)).instance
    
    /// Navigation Bar title
    static let navTitle = Font(.installed(.robotoBold), size: .standard(.h1)).instance
    
    /// Bold Navigation Bar title
    static let navTitleBold = Font(.installed(.robotoBold), size: .standard(.h1)).instance
    
    /// Navigation Bar buttons
    static let navButton = Font(.installed(.robotoRegular), size: .standard(.h4)).instance
    
    /// Text Fields Placeholders
    static let textFieldPlaceHolderFont = Font(.installed(.robotoMedium), size: .standard(.h1)).instance
    
    /// Text Fields Title Fonts
    static let textFieldTitleFont = Font(.installed(.robotoBold), size: .standard(.h5)).instance
    
    /// Text Fields Fonts
    static let textFieldFont = Font(.installed(.robotoRegular), size: .standard(.h3)).instance
    
    /// Form Buttons
    static let formButtons = Font(.installed(.robotoMedium), size: .standard(.h2)).instance
    
    /// Custom string font
    static let helveticaLight13 = Font(.custom("Roboto-Regular"), size: .custom(13.0)).instance
    
    /// FontType
    enum FontType {
        /// installed: installed(FontName)
        case installed(FontName)
        
        /// custom: custom(String)
        case custom(String)
        
        /// system: system
        case system
        
        /// systemBold: systemBold
        case systemBold
        
        /// systemItatic: systemItatic
        case systemItatic
        
        /// systemWeighted: systemWeighted(weight: UIFont.Weight)
        case systemWeighted(weight: UIFont.Weight)
    }
    
    /// FontSize
    enum FontSize {
        /// standard: standard(StandardSize)
        case standard(StandardSize)
        
        /// custom: custom(Double)
        case custom(Double)
        
        /// Value: Double
        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    
    /// FontName
    enum FontName: String {
        case robotoRegular = "Roboto-Regular"
        case robotoThin = "Roboto-Thin"
        case robotoLight = "Roboto-Light"
        case robotoMedium = "Roboto-Medium"
        case robotoBold = "Roboto-Bold"
        case robotoItalic = "Roboto-Italic"
    }
    
    /// StandardSize
    ///
    /// - h1: 20.0
    /// - h2: 18.0
    /// - h3: 16.0
    /// - h4: 14.0
    /// - h5: 12.0
    /// - h6: 10.0
    enum StandardSize: Double {
        ///  h1 = 20.0
        case h1 = 20.0
        
        /// h2 = 18.0
        case h2 = 18.0
        
        /// h3 = 16.0
        case h3 = 16.0
        
        /// h4 = 14.0
        case h4 = 14.0
        
        /// h5 = 12.0
        case h5 = 12.0
        
        /// h6 = 10.0
        case h6 = 10.0
    }
    
    /// FontType
    var type: FontType
    
    /// FontSize
    var size: FontSize
    
    /// init
    ///
    /// - Parameters:
    ///   - type: FontType
    ///   - size: FontSize
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
}

// MARK: - Font
extension Font {
    
    /// UIFont
    var instance: UIFont {
        
        /// Instance Font: UIFont
        var instanceFont: UIFont!
        
        switch type {
        case .custom(let fontName):
            guard let font =  UIFont(name: fontName, size: CGFloat(size.value)) else {
                fatalError("\(fontName) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .installed(let fontName):
            guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                fatalError("\(fontName.rawValue) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .system:
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
        case .systemBold:
            instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
        case .systemItatic:
            instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
        case .systemWeighted(let weight):
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value),
                                             weight: weight)
        }
        return instanceFont
    }
}
