//
//  ProfilePageViewController.swift
//  Motivation
//
//  Created by Atahan Sahlan on 21/01/2021.
//

import UIKit
import SwiftUI

class ProfilePageViewController: UIViewController {
    let userDefaults = UserDefaults(suiteName: "group.Sahlan.Motivation")

    var Quotes: [Quote]?
 
    var UserQuotesText: [String]?
    var UserQuotesAuthor: [String]?
    var numberofUserQuotes = 0
    var numberofFollowers = 0
    var numberofFollowing = 0
    var image = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserFallowerFallowingNumbers()
           getProfilePicture()
        
        


        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       // getProfilePicture()
    }
    func getUserFallowerFallowingNumbers(){
        database().getUsersNumberOfFollowers(){Followers  in
            self.numberofFollowers = Followers
        }
        database().getUsersNumberOfFollowing(){Following in
            self.numberofFollowing = Following
        }
        
    }
    func getProfilePicture(){
        
        DispatchQueue.main.async {
            DatabaseStorage().getProfilePicture(){ Image in
                self.image = Image
                self.getUserQuotes()

            }
        }

    }
    func getUserQuotes(){
        
        UserQuotesText =  userDefaults?.array(forKey: "UserQuotesText") as? [String]
        UserQuotesAuthor =  userDefaults?.array(forKey: "UserQuotesAuthor") as? [String]

        if UserQuotesText?.count != 0 && UserQuotesText  != nil{
        for index in 0...UserQuotesText!.count-1 {
            database().addUserQuote(text: UserQuotesText![index], author: UserQuotesAuthor![index])

        }
            userDefaults?.removeObject(forKey: "UserQuotesText")
            userDefaults?.removeObject(forKey: "UserQuotesAuthor")
            UserQuotesText = []
            UserQuotesAuthor = []

        }
        database().getUserQuotes(){quotes in
            self.numberofUserQuotes = quotes.count

            for quote in quotes{
                self.Quotes?.append(Quote(Text: quote.text, Author: quote.author, Popularity: 0, Category: [""], Number: 999999))

            }
            var columns = 0
            var rows = 0
            if quotes.count > 1{
                columns = 2
            }else{
                columns = 1
            }
            rows = Int(CGFloat(CGFloat(quotes.count)/2.0).rounded(.up))

            if rows == 0 && quotes.count != 0{
                rows = 1
            }
            
            
            let ProfileView = UIHostingController(rootView: ProfilePage(Quotes: quotes, Columns: columns, Rows: rows, ProfilePicture: self.image, NumberOfFollowers: self.numberofFollowing, NumberOfFollowing: self.numberofFollowers))
            self.addConstraints(View: ProfileView)
            
            
        }

    }
    func addConstraints(View: UIHostingController<ProfilePage>){
        self.view.addSubview(View.view)
        View.view.translatesAutoresizingMaskIntoConstraints = false
        View.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        View.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        View.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        View.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

        self.Quotes = self.Quotes?.reversed()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
