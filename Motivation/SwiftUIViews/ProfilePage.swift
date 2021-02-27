//
//  ProfilePage.swift
//  Motivation
//
//  Created by Atahan Sahlan on 19/01/2021.
//

import SwiftUI

struct ProfilePage: View {
    var quotes: [Quote]?
    var columns: Int?
    var rows: Int?
    @State private var isShowPhotoLibrary = false
    @State private var isPresented = false
    var image: UIImage
    var selectedImage = UIImage(systemName: "person.fill")
    var numberofFollowers: Int?
    var numberofFollowing: Int?
    var numberofUserQuotes: Int?


    init(Quotes: [Quote], Columns: Int, Rows: Int, ProfilePicture: UIImage, NumberOfFollowers: Int, NumberOfFollowing: Int){
        quotes = Quotes
        columns = Columns
        rows = Rows
        image = ProfilePicture
        numberofFollowing = NumberOfFollowing
        numberofFollowers = NumberOfFollowers
        numberofUserQuotes = quotes?.count
        
    }
    var body: some View {
        NavigationView {
        VStack{
            Spacer(minLength: 20)
            ZStack{
                Circle().strokeBorder(Color.black,lineWidth: 4)
                    .frame(width: 100, height: 100)
                Image(uiImage: image).resizable().scaledToFill().frame(width:100, height:100).cornerRadius(50)
            }.onTapGesture(perform: {
                isShowPhotoLibrary.toggle()
            })
            Spacer(minLength: 20)
            HStack{
                Spacer()
                VStack{
                    Text(String(numberofFollowing!))
                    Text("Following")
                }
                Spacer()
                VStack{
                    Text(String(numberofFollowers!))
                    Text("Followers")
                }
                Spacer()
                VStack{
                    Text(String(numberofUserQuotes!))
                    Text("Quotes")
                }
                Spacer()
            }
            Spacer(minLength: 20)
            NavigationLink(destination: MyInjector().navigationBarTitle("Settings", displayMode: .large)) {
                ZStack{
                    Rectangle().frame(width:250, height:40).cornerRadius(20).foregroundColor(.green)
                    Text("Edit Profile").foregroundColor(.white).font(.custom("Avenir Medium", size: 21))
                }
                }
//            Button(action: {
//                // your action here
//                
//                isPresented.toggle()
//            }) {
//                ZStack{
//                    Rectangle().frame(width:250, height:40).cornerRadius(20).foregroundColor(.green)
//                    Text("Edit Profile").foregroundColor(.white).font(.custom("Avenir Medium", size: 21))
//                }
//                //Text("Button title")
//            }
            Spacer(minLength: 40)
            posts
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(selectedImage: image, sourceType: .photoLibrary)
        }.navigationBarTitle("Profile", displayMode: .automatic).navigationBarHidden(true)

    }
    }
 
    //MyInjector()
    var posts: some View{
        
        ScrollView(.vertical, showsIndicators: false){
            HStack(spacing: 40) {
                ForEach(0..<columns!) {i in
                    VStack(spacing: 30){
                        ForEach(0..<rows!){j in
                            NavigationLink(destination: SingleView(Quote: quotes![i*columns!+j].text!, Author: quotes![i*columns!+j].author!, BackgroundColor: Colors().Gradientstest[i*columns!+j]).navigationBarTitle("").navigationBarHidden(true).ignoresSafeArea()) {
                                
                                Post(Quote: quotes![i*columns!+j].text!, Author: quotes![i*columns!+j].author!, BackgroundColor: Colors().Gradientstest[i*columns!+j])
                                }
                            
                        }
                      
                    }
                }
               
            }
            
        }
    }
    
    
    
    
}
struct SingleView: View{
    var quote: String?
    var author: String?
    var backroundColor: Gradient?
    init(Quote: String, Author: String, BackgroundColor: Gradient){
        quote = Quote
        author = Author
        backroundColor = BackgroundColor
    }
    var body: some View{
        ZStack{
            Rectangle().ignoresSafeArea().overlay(
                LinearGradient(gradient: backroundColor!, startPoint: .topLeading, endPoint: .bottomTrailing))
            VStack{
                Text(quote!).frame(width: 100, height: 50, alignment: .center).foregroundColor(.white)
                Text(author!).offset( y: 50 ).frame(width: 100, height: 15, alignment: .leading).foregroundColor(.white)
            }
        }
    }
}
struct Post: View {
    var quote: String?
    var author: String?
    var backroundColor: Gradient?
    init(Quote: String, Author: String, BackgroundColor: Gradient){
        quote = Quote
        author = Author
        backroundColor = BackgroundColor
    }
    var body: some View{
    
        ZStack{
            Rectangle().frame(width: 135, height: 215).overlay(
                LinearGradient(gradient: backroundColor!, startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(15)
            
            VStack{
                Text(quote!).minimumScaleFactor(0.1).frame(width: 100, height: 50, alignment: .center).foregroundColor(.white)
                Text(author!).offset( y: 50 ).frame(width: 100, height: 15, alignment: .leading).minimumScaleFactor(0.1).foregroundColor(.white)
            }
            
        }
    }
}
struct ImagePicker: UIViewControllerRepresentable {
     var selectedImage: UIImage
    @Environment(\.presentationMode) private var presentationMode
    func makeCoordinator() -> Coordinator {
        Coordinator(self)

    }
    
 
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
 
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
 
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
 
        return imagePicker
    }
 
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
 
    }
  
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
        var parent: ImagePicker
     
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
     
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                DatabaseStorage().addProfilePicture(Image: image.pngData()!)
                parent.selectedImage = image
            }
     
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage(Quotes: [Quote(Text: "Quote", Author: "Author", Popularity: 0, Category: [""], Number: 999999)], Columns: 1, Rows: 1, ProfilePicture: UIImage(systemName: "person.fill")!, NumberOfFollowers: 1342, NumberOfFollowing: 1312)
    }
}
