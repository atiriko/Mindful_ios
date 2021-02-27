//
//  CategoryPickerView.swift
//  Motivation
//
//  Created by Atahan Sahlan on 23/12/2020.
//

import SwiftUI
import Firebase
var pickedCategories: [String] = []
struct CategoryPickerView: View {
    @State private var isPresented = false
    @Environment(\.presentationMode) var presentationMode

    let selectedCategories: [String]?
    init(SelectedCategories: [String]? = [""]) {
        selectedCategories = SelectedCategories
    }

    let categories = ["Arts","Books","Death","Education","Faith","Friendship","Funny","God","Happiness","Hope", "Humor","Inspiration","Knowledge","Life","Love","Mind","Motivation","Philosophy","Poetry","Positive","Purpose","Relationship","Religion","Romance","Science","Soul","Success","Truth","Wisdom","Writing",]
    var body: some View {
            VStack{
                Text("Categories").bold().font(.largeTitle).offset(x:-90, y: 30)
                Text("Pick the categories you'd like to see").offset(x:-40, y: 50)
                Spacer()
                ScrollView(.horizontal){
                    HStack(spacing: 20) {
                        ForEach(0..<6) {index in
                            VStack(spacing: 20){
                                CategoryBox(text: categories[index], selectedCategories: selectedCategories)
                                CategoryBox(text: categories[index+5], selectedCategories: selectedCategories)
                                CategoryBox(text: categories[index+10], selectedCategories: selectedCategories)
                                CategoryBox(text: categories[index+15], selectedCategories: selectedCategories)
                                CategoryBox(text: categories[index+20], selectedCategories: selectedCategories)

                            }
                           }
                       }
                   
                }.offset(x:10)
              Spacer()

                Button(action: {
                    database().addUserCategories(uid: Auth.auth().currentUser!.uid, categories: pickedCategories)
                    database().initialLaunchCompleted(uid: Auth.auth().currentUser!.uid)
                    //print("done")
//UINavigationController.pushViewController(UITabBarController)
                    
                    isPresented.toggle()
                   
                    // your action here
                }) {
                    ZStack{
                        Rectangle().frame(width: 250, height: 50, alignment: .center).foregroundColor(.gray).cornerRadius(10)
                        Text("Continue").foregroundColor(.white).scaledToFit().minimumScaleFactor(0.5)
                    }
                }.fullScreenCover(isPresented: $isPresented, content:{ TabBarController().edgesIgnoringSafeArea(.all)})
                
                Spacer()
        }
        
    }
   
}
struct CategoryBox: View{

    var text: String?
    var selectedCategories: [String]?
@State var color = Color(Colors().color1)
    var body: some View{
        ZStack{
            
            Rectangle().frame(width: 100, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(color).cornerRadius(10.0)
            Text(text!).frame(width: 90, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }.onTapGesture {
            if color == Color(Colors().color1){
                color = Color(Colors().color2)
                pickedCategories.append(text!)
            }else{
                color = Color(Colors().color1)
                var newarray: [String] = []
                for i in pickedCategories{
                    if i != text{
                        newarray.append(i)
                    }
                }
                pickedCategories = newarray
        }
        }.onAppear(){
            for category in selectedCategories!{
             //   print("asda \(category)")
             //   print(text)

                if category == text{
                    color = Color(Colors().color2)
                }
            }
          
       
        }
}
}
struct TabBarController: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UITabBarController

    func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarController>) -> TabBarController.UIViewControllerType {

    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let mainViewController: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "main") as! UITabBarController
      return mainViewController

    }

    func updateUIViewController(_ uiViewController: TabBarController.UIViewControllerType, context: UIViewControllerRepresentableContext<TabBarController>) {
        //
    }
}
struct CategoryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryPickerView()
    }
}
