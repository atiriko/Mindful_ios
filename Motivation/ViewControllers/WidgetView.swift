//
//  WidgetView.swift
//  Motivation
//
//  Created by Atahan Sahlan on 16/10/2020.
//

import SwiftUI

struct WidgetView: View {
    let text: String?
    let author: String?
    let textColor: UIColor?
    let backroundColor: Gradient?
    let number: Int?
    let type: Int?
    init(Text: String? = "Dam ustunde saksagan vur beline kazmayi", Author: String? = "Perihan Duran", TextColor:UIColor? = .white, BackroundColor: Gradient? = Gradient(colors: [.red, .white]) , Number: Int?, Type: Int?) {
            
            self.text = Text
            self.author = Author
        self.textColor = TextColor
        self.backroundColor = BackroundColor
        self.number = Number
        self.type = Type
        UITableView().register(UITableViewCell.self, forCellReuseIdentifier: "WidgetCell")

        }
    @State private var offset = CGSize.zero

    var body: some View {
      

        ZStack{
//
            InAppQuoteView(Text: text, Author: author, TextColor: textColor, BackroundColor: backroundColor, Number: number, Type: type)
                .clipped()
                .shadow(color: Color(UIColor.lightGray), radius: 5, x: 0, y: 3)

        }
    }
}
struct InAppQuoteView: View {
    let userDefaults = UserDefaults(suiteName: "group.Sahlan.Motivation")
    @State private var rect1: CGRect = .zero

    let text: String?
    let author: String?
    let textColor: UIColor?
    let number: Int?
    let backroundColor: Gradient?
    let type: Int?
    var font: String?
    
    init(Text: String? = "Oops Something Went Wrong", Author: String? = "I mean very wrong", TextColor:UIColor? = .white, BackroundColor: Gradient? = Gradient(colors: [.red, .white]) , Number: Int?, Type: Int?) {
            
            self.text = Text
            self.author = Author
        self.textColor = TextColor
        self.number = Number
        self.type = Type
        self.backroundColor = BackroundColor
        font = userDefaults?.string(forKey: "FavoriteFont")


        }
    @State private var isPaused: Bool = true


    var body: some View{
        ZStack{
            Rectangle().frame(minWidth: 316,  maxWidth:316, minHeight: 145,  maxHeight: 145, alignment: .center).cornerRadius(20).overlay(
                LinearGradient(gradient: backroundColor!, startPoint: .topLeading, endPoint: .bottomTrailing)
            ).cornerRadius(20)

        VStack(alignment: .center ,spacing: 5){
            
            Text(text!).minimumScaleFactor(0.4).font(.custom(font ?? "Montserrat-ExtraBold", size: 16)).frame(maxWidth: 316, alignment: .center).foregroundColor(Color(textColor!))//.shadow(radius: 2)
            HStack{
                if type == 1{
                ZStack{
                    if backroundColor == Colors().Gradients[2] || backroundColor == Colors().Gradients[3] || backroundColor == Colors().Gradients[4] || backroundColor == Colors().Gradients[5]{
                        if !isPaused{
                        Image(systemName: "heart.fill").foregroundColor(.white)
                        }

//                        LottieView(filename: "like", isPaused: isPaused)
//                            .frame(width: 27, height: 30).foregroundColor(.white)
                    }else{
                        Image(systemName: "heart.fill").foregroundColor(.red)
                    }
                   
                    Button(action: {
                        database().addUserFavoriteQuote(text: text!, author: author!, number: number!)
                        var favorites: [Int]?
                        
                        self.isPaused.toggle()

                        favorites =  userDefaults?.array(forKey: "favorites") as? [Int]
                        let favcount = favorites?.count
                        if !isPaused{
                        if favorites == nil{
                            favorites = []
                            favorites?.append(number!)
                        }else{
                            favorites?.append(number!)
                        }
                        }else{
                            if favorites == nil{
                                favorites = []
                                
                            }else{
                                favorites?.remove(at: favcount!-1)
                                
                            }
                        }
                       

                        self.userDefaults?.set(favorites! as Array, forKey: "favorites")
                        
                        // your action here
                    }) {
                        if backroundColor == Colors().Gradients[2] || backroundColor == Colors().Gradients[3] || backroundColor == Colors().Gradients[4] || backroundColor == Colors().Gradients[5]{
                            Image(systemName: "heart").foregroundColor(.white)

                        }else{
                            Image(systemName: "heart").foregroundColor(.red)

                        }
                        
                    }
                }
                }
               
                Button(action: {
                   
                    let data = InAppQuoteView(Text: text, Author: author, TextColor: textColor, BackroundColor: backroundColor, Number: number,Type: 2).takeScreenshot(origin: CGPoint(x: 0,y: 50), size: CGSize(width: 316,height: 145))
                           let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                           UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
                   
                    // your action here
                }) {
                    Image(systemName: "square.and.arrow.up").foregroundColor(.blue)
                }

            Text(author!).frame(maxWidth: 316, alignment: .trailing).minimumScaleFactor(0.3).font(.custom(font ?? "Montserrat-ExtraBold", size: 10)).foregroundColor(Color(textColor!))
                
            }


        }.padding().frame(maxWidth: 316, maxHeight: 144)
        }
        
        
    }
}
struct RectGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { proxy in
            self.createView(proxy: proxy)
        }
    }

    func createView(proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = proxy.frame(in: .global)
        }

        return Rectangle().fill(Color.clear)
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView( Number: 0, Type: 1)
    }
}
extension UIView {
    var renderedImage: UIImage {
        // rect of capure
        let rect = self.bounds
        // create the context of bitmap
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        // get a image from current context bitmap
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImage
    }
}

extension View {
    func takeScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: origin, size: size))
        let hosting = UIHostingController(rootView: self)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.renderedImage
    }
}
extension UIView {
    func takeScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.bounds.size.width, height: self.bounds.size.height), false, UIScreen.main.scale)
        // Draw view in that context
        drawHierarchy(in: CGRect(x: 0,y: 0,width: self.bounds.size.width,height: self.bounds.size.height), afterScreenUpdates: true)

    
        //drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil) {
            //UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil);
            return image!
        }

        return UIImage()
    }
}
extension UIView {
    func asImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
