//
//  Quote.swift
//  Motivation
//
//  Created by Atahan Sahlan on 24/10/2020.
//

import Foundation
import UIKit
import SwiftUI

public class Quote: Equatable{
    public static func == (lhs: Quote, rhs: Quote) -> Bool {
        if lhs.text == rhs.text && lhs.author == rhs.author{
            return true
        }else{
            return false
        }
    }
    
    let text: String?
    let author: String?
    let popularity: Double?
    let category: [String]?
    let number: Int?
    let backroundColor: Gradient?
    let textColor: UIColor?
    var isLiked = false
    
    init(Text: String?, Author: String?, Popularity: Double?, Category: [String]?, Number: Int?, Color: Gradient? = Colors().gradient1){
        text = Text
        author = Author
        popularity = Popularity
        category = Category
        number = Number
        backroundColor = Color
        textColor = Colors().color2

//        switch backroundColor {
//         case Colors().gradient1:
//                textColor = Colors().color5
//            case Colors().gradient2:
//                textColor = Colors().color5
//            case Colors().gradient3:
//                textColor = Colors().color2
//            case Colors().gradient4:
//                textColor = Colors().color2
//            case Colors().gradient5:
//                textColor = Colors().color2
//            case Colors().gradient6:
//                textColor = Colors().color2
//            case Colors().gradient7:
//                textColor = Colors().color5
//            case Colors().gradient8:
//                textColor = Colors().color2
//            case Colors().gradient9:
//                textColor = Colors().color2
//            case Colors().gradient10:
//                textColor = Colors().color5
//            case Colors().gradient11:
//                textColor = Colors().color5
//            default:
//                textColor = Colors().color2
            }
        
    }
//    switch Int.random(in: 1...11) {
//    case 1:
//        backroundColor = Colors().gradient1
//        textColor = Colors().color5
//    case 2:
//        backroundColor = Colors().gradient2
//        textColor = Colors().color5
//    case 3:
//        backroundColor = Colors().gradient3
//        textColor = Colors().color2
//    case 4:
//        backroundColor = Colors().gradient4
//        textColor = Colors().color2
//    case 5:
//        backroundColor = Colors().gradient5
//        textColor = Colors().color2
//    case 6:
//        backroundColor = Colors().gradient6
//        textColor = Colors().color2
//    case 7:
//        backroundColor = Colors().gradient7
//        textColor = Colors().color5
//    case 8:
//        backroundColor = Colors().gradient8
//        textColor = Colors().color2
//    case 9:
//        backroundColor = Colors().gradient9
//        textColor = Colors().color2
//    case 10:
//        backroundColor = Colors().gradient10
//        textColor = Colors().color5
//    case 11:
//        backroundColor = Colors().gradient11
//        textColor = Colors().color5
//    default:
//        backroundColor = Colors().gradient1
//        textColor = Colors().color5
//
//    }
//

