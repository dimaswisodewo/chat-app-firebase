//
//  Extensions.swift
//  Chat App Firebase
//
//  Created by Dimas Wisodewo on 04/05/23.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}

extension UITextField {
    
    func isError(baseColor: CGColor, numberOfShakes shakes: Float, revert: Bool) {
        
        let borderAnim: CABasicAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        borderAnim.fromValue = 0
        borderAnim.toValue = 1
        borderAnim.duration = 0.4
        borderAnim.autoreverses = revert
        self.layer.add(borderAnim, forKey: nil)
        
        let shadowAnim: CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
        shadowAnim.fromValue = baseColor
        shadowAnim.toValue = UIColor.red.cgColor
        shadowAnim.duration = 0.4
        shadowAnim.autoreverses = revert
        self.layer.add(shadowAnim, forKey: nil)

        let positionAnim: CABasicAnimation = CABasicAnimation(keyPath: "position")
        positionAnim.duration = 0.07
        positionAnim.repeatCount = shakes
        positionAnim.autoreverses = revert
        positionAnim.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        positionAnim.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(positionAnim, forKey: nil)
    }
}
