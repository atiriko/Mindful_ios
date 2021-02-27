//
//  Database.swift
//  Motivation
//
//  Created by Atahan Sahlan on 24/10/2020.
//

import Foundation
import FirebaseDatabase
import Firebase



public class database{
    var ref = Database.database().reference()
    var quotesRef = Database.database().reference().child("Quotes")
    let userDefaults = UserDefaults(suiteName: "group.Sahlan.Motivation")
  
  
    func getUsersNumberOfFollowers(Followers: @escaping (Int) -> Void){
        var followers = 0
       
        ref.child("Users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {snapshot in
            
            for user_child in (snapshot.children){
                let user_snap = user_child as! DataSnapshot
                if user_snap.key == "Followers"{
                    var i = 0
                    for _ in user_snap.children{
                        i += 1
                    }
                    followers = i
                }
            }
            Followers(followers)

        })
    }
    func getUsersNumberOfUserQuotes(NumberOfQuotes: @escaping (Int) -> Void){
            self.getUserQuotes(){quotes in
                NumberOfQuotes(quotes.count)
            }
            
    }
    func getUsersNumberOfFollowing(Following: @escaping (Int) -> Void){
        var following = 0
        ref.child("Users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {snapshot in
            for user_child in (snapshot.children){
                let user_snap = user_child as! DataSnapshot
                if user_snap.key == "Following"{
                    var i = 0
                    for _ in user_snap.children{
                        i += 1
                    }
                    following = i
                    
                }
            }
            Following(following)

            
        })
    }
    
    func createUser(email: String, username: String, uid:String){
        ref.child("Users/\(uid)/username").setValue(username)
        ref.child("Users/\(uid)/email").setValue(email)
        ref.child("Users/\(uid)/uid").setValue(uid)
        
    }
    func getUserFavoriteQuotes(Quotes: @escaping ([Quote]) -> Void){
        if Auth.auth().currentUser != nil{
        let userRef = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favoriteQuotes")
        var quotes: [Quote] = []
        var text: String?
        var number: Int?
        var author: String?
        userRef.observeSingleEvent(of: .value, with: {snapshot in
            for user_child in (snapshot.children) {
                let user_snap = user_child as! DataSnapshot
                for child in user_snap.children{
                    let snap = child as! DataSnapshot
                    
                    if snap.key == "quote"{
                        text = snap.value as? String
                    }
                    if snap.key == "author"{
                        author = snap.value as? String
                    }
                    if snap.key == "number"{
                        number = snap.value as? Int
                    }              
                    
                }

                quotes.append(Quote(Text: text, Author: author, Popularity: 0, Category: [""], Number: number))
            }
            Quotes(quotes)
        })
        }
    }
    func addUserFavoriteQuote( text:String, author:String, number:Int){
        if Auth.auth().currentUser != nil{
        ref.child("Users/\(Auth.auth().currentUser!.uid)/favoriteQuotes").child(String(number)).setValue(["quote" : text,  "author": author, "number": number])
        }
    }
    func deleteUserFavoriteQuote(number: Int){
        if Auth.auth().currentUser != nil{
            ref.child("Users").child(Auth.auth().currentUser!.uid).child("favoriteQuotes").child(String(number)).removeValue()
            
        }
    }
    func addUserQuote( text:String, author:String){
        if Auth.auth().currentUser != nil{

        ref.child("Users/\(Auth.auth().currentUser!.uid)/userQuotes").childByAutoId().setValue(["quote" : text,  "author": author, "number": 999999])
        }
    }
    func getUserQuotes(Quotes: @escaping ([Quote]) -> Void){
        if Auth.auth().currentUser != nil{

        let userRef = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("userQuotes")
        var quotes: [Quote] = []
        var text: String?
        var number: Int?
        var author: String?
        userRef.observeSingleEvent(of: .value, with: {snapshot in
            for user_child in (snapshot.children) {
                //print(user_child)
                let user_snap = user_child as! DataSnapshot
                for child in user_snap.children{
                    let snap = child as! DataSnapshot
                    
                    if snap.key == "quote"{
                        text = snap.value as? String
                    }
                    if snap.key == "author"{
                        author = snap.value as? String
                    }
                    if snap.key == "number"{
                        number = snap.value as? Int
                    }
                    
                }

                quotes.append(Quote(Text: text, Author: author, Popularity: 0, Category: [""], Number: number))
            }
            Quotes(quotes)
        })
        }
    }
    func deleteAllUserQuotes(){
        if Auth.auth().currentUser != nil{

        ref.child("Users").child(Auth.auth().currentUser!.uid).child("userQuotes").removeValue()
        }
    }

    func deleteAllFavoriteQuotes(){
        if Auth.auth().currentUser != nil{

        ref.child("Users").child(Auth.auth().currentUser!.uid).child("favoriteQuotes").removeValue()
        }
    }
    func addUserCategories(uid: String, categories: [String]){
        ref.child("Users/\(uid)/categories").setValue(categories)
    }
    func isInitialLaunch(uid: String, bool: @escaping (Bool) -> Void){
        let userRef = Database.database().reference().child("Users").child(uid)
        var isinitial = true
        userRef.observeSingleEvent(of: .value, with: {snapshot in
            for user_child in (snapshot.children) {
                
                let user_snap = user_child as! DataSnapshot
                if user_snap.value is Bool{
                    if user_snap.key == "isInitialLaunch"{
                        isinitial = user_snap.value as? Bool ?? true
                    }
                    
                }
            }
            bool(isinitial)
        })
    }
    func initialLaunchCompleted(uid: String){
        ref.child("Users/\(uid)/isInitialLaunch").setValue(false)
        
    }
    func getUserFavoriteCategories(Categories: @escaping ([String]) -> Void){
        var categories: [String]?
        if Auth.auth().currentUser != nil{
            ref.child("Users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {snapshot in
                
                for user_child in (snapshot.children){
                    let user_snap = user_child as! DataSnapshot
                    if user_snap.value is [String]{
                        if user_snap.key == "categories"{
                            categories = user_snap.value as? [String] ?? [""]
                        }
                    }
                }
                Categories(categories ?? [""])
            })
        }
    }
    func getQuoteNew(number: Int? = -1,categories: [String]? = [""], quote: @escaping (Quote) -> Void){
        quotesRef.child(String(number!)).observeSingleEvent(of: .value, with: {snapshot in
            var text: String?
            var author: String?
            var popularity: Double?
            var category: [String]?
            var isCategoryRight = false
            for user_child in (snapshot.children) {
                
                let user_snap = user_child as! DataSnapshot
                if user_snap.value is String{
                    if user_snap.key == "quote"{
                        text = user_snap.value as? String
                        self.userDefaults?.set(text! as String, forKey: "QuoteText")
                    }else if user_snap.key == "author"{
                        author = user_snap.value as? String
                        self.userDefaults?.set(author! as String, forKey: "QuoteAuthor")
                    }else if user_snap.key == "Popularity"{
                        popularity = user_snap.value as? Double
                    }
                    self.userDefaults?.synchronize()
                    
                }
                if user_snap.value is [String]{
                    if user_snap.key == "category"{
                        category = user_snap.value as? [String] ?? [""]
                    }
                }
                
                
                
            }
            if categories != [""]{
                for cat in category!{
                    for sel in categories!{
                                     //   print(cat)
                                     //   print(sel)
                        if cat == sel.lowercased(){
                            isCategoryRight = true
                            
                        }
                    }
        
                }
            }else{
                quote(Quote.init(Text: text, Author: author, Popularity: popularity, Category: category, Number: number))
            }
           // print(isCategoryRight)
            if isCategoryRight{
                quote(Quote.init(Text: text, Author: author, Popularity: popularity, Category: category, Number: number))
            }
            
            
        })
    }
    func getQuote(number: Int? = -1, quote: @escaping (Quote) -> Void){
        ref.child(String(number!)).observeSingleEvent(of: .value, with: {snapshot in
            var text: String?
            var author: String?
            var popularity: Double?
            var category: [String]?
            for user_child in (snapshot.children) {
                
                let user_snap = user_child as! DataSnapshot
                if user_snap.value is String{
                    if user_snap.key == "Quote"{
                        text = user_snap.value as? String
                        self.userDefaults?.set(text! as String, forKey: "QuoteText")
                    }else if user_snap.key == "Author"{
                        author = user_snap.value as? String
                        self.userDefaults?.set(author! as String, forKey: "QuoteAuthor")
                    }else if user_snap.key == "Popularity"{
                        popularity = user_snap.value as? Double
                    }else if user_snap.key == "Catagorie"{
                        category = user_snap.value as? [String]
                    }
                    self.userDefaults?.synchronize()
                    
                }
                
                
                
            }
            
            if text == nil{
                self.getQuoteNew(number: number){Quote in
                    quote(Quote)
                }
            }else{
                quote(Quote.init(Text: text, Author: author, Popularity: popularity, Category: category, Number: number))
                
            }
        })
    }
    func getQuotesForFeed(Quotes: @escaping ([Quote]) -> Void){
        let startpoint = Int.random(in: 1...Variables().NumberOfQuotesAtDatabase)
        var quotes: [Quote]
        quotes = []

        
            getUserFavoriteCategories(){categories in
          
            for index in 0...100 {
//                if index > 50 && quotes == []{
//                    self.getQuoteNew(number: startpoint+index){ (quote) in
//                        quotes.append(quote)
//                        if index == 100{
//                            //Quotes(quotes)
//                        }
//
//                    }
//                }else{
                    self.getQuoteNew(number: startpoint+index,categories: categories) { (Quote) in
                        
                        quotes.append(Quote)
                        if index > 50 && (quotes == [] || quotes.count < 20){
                            self.getQuoteNew(number: startpoint+index){ (quote) in
                                quotes.append(quote)
                                if index == 100{
                                    print("kategorisiz")
                                    Quotes(quotes)
                                }

                            }
                        }else{
                            if index == 100{
                                print("kategorili")

                                Quotes(quotes)
                            }
                        }

                    }
                }
                
                }
            }
        
    
    func loadMoreQuotesForFeed(Quotes: @escaping ([Quote]) -> Void){
        let startpoint = Int.random(in: 1...Variables().NumberOfQuotesAtDatabase)
        var quotes: [Quote]
        quotes = []
        for index in 0...50 {
            getQuoteNew(number: startpoint+index) { (Quote) in
                
                quotes.append(Quote)
                if index == 50{
                    
                    Quotes(quotes)
                    
                }
            }
            
        }
        
        
    }
    
}

