//
//  ASImageView.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation
import UIKit

/// This class will be used to extend the property for border, border color and corner radius in storyboard designs.
@IBDesignable class ASImageView: UIImageView {
    
    /// Border Width
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            if borderWidth > 0 {
                layer.borderWidth = borderWidth
            }
        }
    }
    
    /// Border Color
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    /// Corner radius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
}
