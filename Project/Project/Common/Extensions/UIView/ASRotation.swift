//
//  ASRotation.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation
import UIKit
/// Extension to rotate a uiview
extension UIView {
    
    /// Start rotating a view
    /// - Parameter duration: Double, 'default = 1.5'
    func startRotating(duration: Double = 1.5) {
        let kAnimationKey = "rotation"
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity

            animate.fromValue = 0.0
            animate.toValue = Float(Double.pi * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    /// Pause a rotating view
    func pauseRotating() {
        guard let transform = self.layer.presentation()?.transform else { return }
        self.layer.transform = transform
        self.layer.removeAllAnimations()
    }
    
    //Stop rotating view
    func stopRotating() {
        let kAnimationKey = "rotation"
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
    
}
