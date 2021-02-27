//
//  Colors.swift
//  Motivation
//
//  Created by Atahan Sahlan on 26/10/2020.
//

import Foundation
import UIKit
import SwiftUI

class Colors{
    
    let BackroundGradient1a = hexStringToUIColor(hex: "f8d905")
    let BackroundGradient1b = hexStringToUIColor(hex: "fdea72")
    
    let BackroundGradient2a = hexStringToUIColor(hex: "0c9bff")
    let BackroundGradient2b = hexStringToUIColor(hex: "abdbff")
    
    let BackroundGradient3a = hexStringToUIColor(hex: "ec5c5c")
    let BackroundGradient3b = hexStringToUIColor(hex: "ffb590")
    
    let BackroundGradient4a = hexStringToUIColor(hex: "7b6bf1")
    let BackroundGradient4b = hexStringToUIColor(hex: "ce9ffd")
    
    let BackroundGradient5a = hexStringToUIColor(hex: "34cd7a")
    let BackroundGradient5b = hexStringToUIColor(hex: "85f9ba")


    let aBackgroundGradients = [Gradient(colors: [hexStringToColor(hex: "f8d905"), hexStringToColor(hex: "fdea72")]),
                     Gradient(colors: [hexStringToColor(hex: "0c9bff"), hexStringToColor(hex: "abdbff")]),
                     Gradient(colors: [hexStringToColor(hex: "ec5c5c"), hexStringToColor(hex: "ffb590")]),
                     Gradient(colors: [hexStringToColor(hex: "7b6bf1"), hexStringToColor(hex: "ce9ffd")]),
                     Gradient(colors: [hexStringToColor(hex: "34cd7a"), hexStringToColor(hex: "85f9ba")]),
                  
    ]

    let color1 = UIColor(red: 41/255, green: 167/255, blue: 216/255, alpha: 1)
    let color2 = UIColor(red: 227/255, green: 238/255, blue: 242/255, alpha: 1)
    let color3 = UIColor(red: 105/255, green: 67/255, blue: 242/255, alpha: 1)
    let color4 = UIColor(red: 242/255, green: 93/255, blue: 60/255, alpha: 1)
    let color5 = UIColor(red: 12/255, green: 12/255, blue: 12/255, alpha: 1)
    
    let Gradients = [Gradient(colors: [hexStringToColor(hex: "FAD961"), hexStringToColor(hex: "F7681C")]),
                     Gradient(colors: [hexStringToColor(hex: "F2D50F"), hexStringToColor(hex: "DA0641")]),
                     Gradient(colors: [hexStringToColor(hex: "F5515F"), hexStringToColor(hex: "A1051D")]),
                     Gradient(colors: [hexStringToColor(hex: "F36265"), hexStringToColor(hex: "961276")]),
                     Gradient(colors: [hexStringToColor(hex: "FF5789"), hexStringToColor(hex: "A704FD")]),
                     Gradient(colors: [hexStringToColor(hex: "C56CD6"), hexStringToColor(hex: "3425AF")]),
                     Gradient(colors: [hexStringToColor(hex: "15F5FD"), hexStringToColor(hex: "036CDA")]),
                     Gradient(colors: [hexStringToColor(hex: "0FF0B3"), hexStringToColor(hex: "036ED9")]),
                     Gradient(colors: [hexStringToColor(hex: "B3EB50"), hexStringToColor(hex: "429421")]),
                     Gradient(colors: [hexStringToColor(hex: "B3EB50"), hexStringToColor(hex: "429421")]),
                     Gradient(colors: [hexStringToColor(hex: "DFEC51"), hexStringToColor(hex: "73AA0A")])
    ]
    let BackroundGradient = Gradient(colors: [hexStringToColor(hex: "C7EC86"),hexStringToColor(hex: "5CDEBB")])
   
    let Gradientstest = [Gradient(colors: [hexStringToColor(hex: "EF5E6C"), hexStringToColor(hex: "F8A3A8")]),
                     Gradient(colors: [hexStringToColor(hex: "F8A3A8"), hexStringToColor(hex: "F3C6A5")]),
                     Gradient(colors: [hexStringToColor(hex: "F3C6A5"), hexStringToColor(hex: "E5E1AB")]),
                     Gradient(colors: [hexStringToColor(hex: "E5E1AB"), hexStringToColor(hex: "9CDCAA")]),
                     Gradient(colors: [hexStringToColor(hex: "9CDCAA"), hexStringToColor(hex: "96CAF7")]),
                     Gradient(colors: [hexStringToColor(hex: "96CAF7"), hexStringToColor(hex: "BFB2F3")]),
                     Gradient(colors: [hexStringToColor(hex: "BFB2F3"), hexStringToColor(hex: "E1B3F2")]),
                  
    ]
    
    let gradient1 = Gradient(colors: [hexStringToColor(hex: "FAD961"), hexStringToColor(hex: "F7681C")])
    let gradient2 = Gradient(colors: [hexStringToColor(hex: "F2D50F"), hexStringToColor(hex: "DA0641")])
    let gradient3 = Gradient(colors: [hexStringToColor(hex: "F5515F"), hexStringToColor(hex: "A1051D")])
    let gradient4 = Gradient(colors: [hexStringToColor(hex: "F36265"), hexStringToColor(hex: "961276")])
    let gradient5 = Gradient(colors: [hexStringToColor(hex: "FF5789"), hexStringToColor(hex: "A704FD")])
    let gradient6 = Gradient(colors: [hexStringToColor(hex: "C56CD6"), hexStringToColor(hex: "3425AF")])
    let gradient7 = Gradient(colors: [hexStringToColor(hex: "15F5FD"), hexStringToColor(hex: "036CDA")])
    let gradient8 = Gradient(colors: [hexStringToColor(hex: "0FF0B3"), hexStringToColor(hex: "036ED9")])
    let gradient9 = Gradient(colors: [hexStringToColor(hex: "B3EB50"), hexStringToColor(hex: "429421")])
    let gradient10 = Gradient(colors: [hexStringToColor(hex: "B3EB50"), hexStringToColor(hex: "429421")])
    let gradient11 = Gradient(colors: [hexStringToColor(hex: "DFEC51"), hexStringToColor(hex: "73AADA")])
 
    

   
}
func hexStringToColor (hex:String) -> Color {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return Color.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return Color(
        red: Double(CGFloat((rgbValue & 0xFF0000) >> 16)) / 255.0,
        green: Double(CGFloat((rgbValue & 0x00FF00) >> 8)) / 255.0,
        blue: Double(CGFloat(rgbValue & 0x0000FF) / 255.0)
    )
    
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
    let red = CGFloat(Double(CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0))
    let green = CGFloat(Double(CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0))
    let blue = CGFloat(Double(CGFloat(rgbValue & 0x0000FF) / 255.0))
    
    let color = UIColor(red:red, green: green, blue: blue , alpha: 1)
    
    return color
}


