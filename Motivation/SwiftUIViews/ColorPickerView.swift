//
//  ColorPickerView.swift
//  Motivation
//
//  Created by Atahan Sahlan on 11/10/2020.
//

import SwiftUI

var pickedColor: UIColor?

struct ColorPickerView: View {
    let text: String?
        init(Text: String? = "Set the background color") {
            
            self.text = Text
        }
    @State public var bgColor = Color.white
    let userDefaults = UserDefaults(suiteName: "group.Sahlan.Motivation")
       

    var body: some View {
        ZStack{
            Rectangle().foregroundColor(.blue).frame(width: 200, height: 40, alignment: .center).cornerRadius(20).onTapGesture(perform: {
               // ColorPickerView.self.
                print("sadf")
            })
            Text("\(text!):")

            ColorPicker(
                   "",
                   selection: $bgColor
            ).frame(width: 200, height: 150)
            ColorPicker("", selection: $bgColor, supportsOpacity: false).frame(width: 200, height: 40, alignment: .leading).offset(x: -100, y: 0).onChange(of: bgColor, perform: { value in
                
                if (text == "Text Color"){
                    
                    userDefaults?.set(  bgColor.cgColor?.components![0], forKey: "TextColorR")
                    userDefaults?.set(  bgColor.cgColor?.components![1], forKey: "TextColorG")
                    userDefaults?.set(  bgColor.cgColor?.components![2], forKey: "TextColorB")
                }else{
                userDefaults?.set(  bgColor.cgColor?.components![0], forKey: "ColorR")
                userDefaults?.set(  bgColor.cgColor?.components![1], forKey: "ColorG")
                userDefaults?.set(  bgColor.cgColor?.components![2], forKey: "ColorB")
                }
                
             
            }).frame(width: 200, height: 40).cornerRadius(20.0)
            
          

        }
    }
   
}


struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView()
    }
}

