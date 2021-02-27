//
//  AddQuoteView.swift
//  Motivation
//
//  Created by Atahan Sahlan on 24/10/2020.
//

import SwiftUI

import SwiftUI

struct AddQuoteView: View {

    let textColor: UIColor?
    let backroundColor: UIColor?
    @State var quote: Quote?
    @Environment(\.presentationMode) var presentationMode

    init(TextColor:UIColor? = .white, BackroundColor: UIColor? = .black) {
            
        
        self.textColor = TextColor
        self.backroundColor = BackroundColor
        UITableView().register(UITableViewCell.self, forCellReuseIdentifier: "WidgetCell")

        }
    @State public var text: String = ""
    @State public var author: String = ""
    var body: some View {
        VStack{
        ZStack{
            Rectangle().foregroundColor(Color(backroundColor!)).frame(minWidth: 316,  maxWidth:316, minHeight: 145,  maxHeight: 145, alignment: .center).cornerRadius(20).shadow(color: .gray, radius: 3, x: 0, y: 5)
            
            
                VStack(alignment: .center ,spacing: 5){
                    
                    TextField("Your Quote", text: $text).foregroundColor(.black).minimumScaleFactor(0.4).font(.caption).frame(maxWidth: 316, alignment: .center)                .textFieldStyle(RoundedBorderTextFieldStyle.init())


                    HStack{

                        Spacer(minLength: 50)
                        TextField("Author", text: $author).foregroundColor(.black).minimumScaleFactor(0.4).font(.caption).frame(maxWidth: 316, alignment: .center)                .textFieldStyle(RoundedBorderTextFieldStyle.init())
                        
                        
                    }


                }.padding().frame(maxWidth: 316, maxHeight: 144)
                
                
            

//            )
        }
            Button(action: {
                if text != "" && author != ""{
                    database().addUserQuote(text: text, author: author)
//                if UserQuotesText == nil{
//                    UserQuotesText = []
//                    UserQuotesText?.append(text)
//
//                }else{
//                    UserQuotesText?.append(text)
//                }
//
//                if UserQuotesAuthor == nil{
//                    UserQuotesAuthor = []
//                    UserQuotesAuthor?.append(author)
//
//                }else{
//                    UserQuotesAuthor?.append(author)
//                }
//
//
//
//                userDefaults?.set(UserQuotesText! as Array, forKey: "UserQuotesText")
//                userDefaults?.set(UserQuotesAuthor! as Array, forKey: "UserQuotesAuthor")
                }

                text = ""
                author = ""
                // your action here
            }) {
                ZStack{
                    Rectangle().foregroundColor(.white).frame(minWidth: 40, idealWidth: 60, maxWidth: 60, minHeight: 40, idealHeight: 60, maxHeight: 60, alignment: .center).cornerRadius(30).shadow(color: .gray, radius: 2, x: 0, y: 5)
                Image(systemName: "plus.circle.fill").resizable().foregroundColor(.blue).frame(minWidth: 40, idealWidth: 60, maxWidth: 60, minHeight: 40, idealHeight: 60, maxHeight: 60, alignment: .center)
                }
                //Text("Button title")
            }
        }
    }
}



struct AddQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuoteView()
    }
}

