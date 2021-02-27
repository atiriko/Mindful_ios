//
//  BackgroundGradientView.swift
//  Motivation
//
//  Created by Atahan Sahlan on 31/12/2020.
//

import UIKit

class BackgroundGradientView: UIView {

    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors =  [hexStringTocgColor(hex: "C7EC86"), hexStringTocgColor(hex: "5CDEBB")]
        //gradientLayer.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
    func hexStringTocgColor (hex:String) -> CGColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray.cgColor
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        let red = CGFloat(Double(CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0))
        let green = CGFloat(Double(CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0))
        let blue = CGFloat(Double(CGFloat(rgbValue & 0x0000FF) / 255.0))
        
        let color = UIColor(red:red, green: green, blue: blue , alpha: 1)
        
        return color.cgColor
    }
}


