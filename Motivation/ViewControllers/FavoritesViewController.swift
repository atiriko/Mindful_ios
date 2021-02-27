//
//  FavoritesViewController.swift
//  Motivation
//
//  Created by Atahan Sahlan on 20/10/2020.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let userDefaults = UserDefaults(suiteName: "group.Sahlan.Motivation")
    
    @IBOutlet weak var tableView: UITableView!
    
    var Quotes: [Quote]?
    var favoriteQuotes: [String]?
    var favoriteAuthors: [String]?
    
    var UserQuotesText: [String]?
    var UserQuotesAuthor: [String]?
    var numberofUserQuotes = 0
    var numberOfSections = 2


    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confiqureTableView()
      
        configureRefreshControl()
        //getFavoriteQuotes()
      //  getUserQuotes()
        //print(tableView.numberOfRows(inSection: 0))

        //database().deleteAllFavoriteQuotes()
        
        // Do any additional setup after loading the view.
    }
    func confiqureTableView(){
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 190
        self.tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: "WidgetCell")
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    func configureRefreshControl () {
        // Add the refresh control to your UIScrollView object.
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                                #selector(handleRefreshControl),
                                            for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        getFavoriteQuotes()
        getUserQuotes()
        Quotes = Quotes?.reversed()


   
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
  
    func getFavoriteQuotes(){
        let alertController = UIAlertController(title: "There Is A Connection Issue", message: "Check your connection", preferredStyle: UIAlertController.Style.alert)

        if Reachability.isConnectedToNetwork(){
            alertController.dismiss(animated: true) {
            }
        }else{
            
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default))
    self.present(alertController, animated: true,completion: nil)

        }
        var favorites: [Int]?
        favorites = []
         favoriteQuotes = userDefaults?.array(forKey: "favoriteQuotes") as? [String]
         favoriteAuthors = userDefaults?.array(forKey: "favoriteAuthors") as? [String]
        
        var favQuotes:[String] = []
        var favAuthors:[String] = []
//        favoriteQuotes = []
//        favoriteAuthors = []
//
//        favoriteQuotes = userDefaults?.array(forKey: "favoriteQuotes") as? [String]
//        favoriteAuthors = userDefaults?.array(forKey: "favoriteAuthors") as? [String]
        
        favorites =  userDefaults?.array(forKey: "favorites") as? [Int]
        Quotes = []
       // print(favoriteQuotes)
        if favoriteQuotes != nil && favoriteQuotes!.count > 0{
            for index in 0...favoriteQuotes!.count-1{
                Quotes?.append(Quote(Text: favoriteQuotes![index], Author: favoriteAuthors![index], Popularity: 0, Category: [""], Number: 999999))
                //print(favoriteQuotes![index])
                //Quotes = Quotes?.reversed()
                //print("buraso")
                self.tableView.reloadData()

            }
        }else{
        favorites?.forEach{
            database().getQuote(number: $0){(quote)in
                self.Quotes?.append(quote)
                self.tableView.reloadData()
                
               

                favQuotes.append(quote.text!)
                favAuthors.append(quote.author!)

                
               // print(favQuotes)
                //print(favQuotes)
                 self.userDefaults?.set(favQuotes as Array, forKey: "favoriteQuotes")
                 self.userDefaults?.set(favAuthors as Array, forKey: "favoriteAuthors")
               
            }
                
            }
           

        }
        database().getUserFavoriteQuotes(){ quotes in
            for quote in quotes{
                self.Quotes?.append(Quote(Text: quote.text!, Author: quote.author!, Popularity: 0, Category: [""], Number: quote.number!))
                self.tableView.reloadData()

            }
            //print(quotes[0].text)
        }
    }
    func getUserQuotes(){
        


        UserQuotesText =  userDefaults?.array(forKey: "UserQuotesText") as? [String]
        UserQuotesAuthor =  userDefaults?.array(forKey: "UserQuotesAuthor") as? [String]


       // Quotes?.reverse()

        if UserQuotesText?.count != 0 && UserQuotesText  != nil{
        for index in 0...UserQuotesText!.count-1 {
            database().addUserQuote(text: UserQuotesText![index], author: UserQuotesAuthor![index])
            
//            Quotes?.append(Quote(Text: UserQuotesText![index], Author: UserQuotesAuthor![index], Popularity: 1, Category: ["UserQuotes"], Number: 999999))

                //self.tableView.reloadData()

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
            self.tableView.reloadData()

            self.Quotes = self.Quotes?.reversed()
        }

    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { [self]  (contextualAction, view, boolValue) in
//            if indexPath.section == 0{
//                self.Quotes?.reverse()
//                if self.Quotes?.count != 0{
//                self.Quotes!.remove(at:indexPath.row)
//                }
//                self.Quotes?.reverse()
//
//                var favorites: [Int]?
//
//                favorites =  self.userDefaults?.array(forKey: "favorites") as? [Int]
//
//                favorites?.reverse()
//                if favorites?.count != 0{
//
//                    favorites?.remove(at: indexPath.row)
//                    favorites?.reverse()
//
//
//                }else{
//                    favorites = []
//                    numberOfSections = 1
//                    tableView.reloadData()
//                }
////                if favorites?.count == 1{
////                    favorites = []
////                    numberOfSections = 1
////                    tableView.reloadData()
////                }
//
//
//
//                self.userDefaults?.set(favorites! as Array, forKey: "favorites")
//                getFavoriteQuotes()
//                getUserQuotes()
//
//            }else{
//
//
//                var userQuotesText: [String]?
//                var userQuotesAuthor: [String]?
//
//
//                userQuotesText =  userDefaults?.array(forKey: "UserQuotesText") as? [String]
//                userQuotesAuthor =  userDefaults?.array(forKey: "UserQuotesAuthor") as? [String]
//                if self.Quotes?.count != 0{
//                self.Quotes?.remove(at: indexPath.row)
//
//                }
//                if self.UserQuotesText!.count != 0{
//                    userQuotesText?.remove(at: UserQuotesText!.count - (indexPath.row+1))
//                    userQuotesAuthor?.remove(at:  UserQuotesAuthor!.count - (indexPath.row+1))
//                    tableView.reloadData()
//
//                }else{
//                    userQuotesText = []
//                    userQuotesAuthor = []
//
//                    numberOfSections = 1
//                    tableView.reloadData()
//                }
//
//
//                self.userDefaults?.set(userQuotesText! as Array, forKey: "UserQuotesText")
//                self.userDefaults?.set(userQuotesText! as Array, forKey: "UserQuotesAuthor")
//
//
//                getFavoriteQuotes()
//                getUserQuotes()
//            }
//
//
//        }
//
//        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
//
//        return swipeActions
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavoriteQuotes()
        getUserQuotes()
        Quotes = Quotes?.reversed()
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0{
            if Quotes != nil{
                if UserQuotesText != nil{
                    if( Quotes!.count - UserQuotesText!.count == 0 && UserQuotesText!.count == 0){
                        //print("annen")
                        let image = UIImage(named: "Empty")
                                let noDataImage = UIImageView(image: image)
                                noDataImage.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.frame.height/4)
                                tableView.backgroundView = noDataImage
                        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.bounds.width, height: view.frame.height/2)
                        numberOfSections = 1
                        //tableView.isHidden = true

                       // tableView.backgroundView!.addSubview(noDataImage)
                    }else{
                       // print("baban")
                        numberOfSections = 2
                        let colorView = UIView()
                        colorView.backgroundColor = UIColor.white
                        tableView.backgroundView = colorView
                    }

                    return Quotes!.count - UserQuotesText!.count
                }else{

                    return Quotes!.count - numberofUserQuotes
                }
            }else{
               // let emptyView = UIImage(systemName: "heart")
//                let image = UIImage(named: "Empty")
//                        let noDataImage = UIImageView(image: image)
//                        noDataImage.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.frame.height)
//                        tableView.backgroundView = noDataImage
//                        tableView.separatorStyle = .none
//                //tableView.isHidden = true
//
//                tableView.backgroundView!.addSubview(noDataImage)

                return 0
            }
        }else{
            return numberofUserQuotes

//            if UserQuotesText != nil{
//
//                return UserQuotesText!.count
//            }else{
//
//                return 0
//            }
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()

        if section == 1{
    
        label.text = "     Your Quotes"
            label.font = UIFont.preferredFont(forTextStyle: .headline)
            label.backgroundColor = .white
        
        return label
        }else{
            label.text = ""
            return label
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetCell") as! FavoritesTableViewCell
    

        if indexPath.section == 0{
            cell.set(Text: Quotes!.reversed()[indexPath.row].text!, Author: Quotes!.reversed()[indexPath.row].author!, BackroundColor: Colors().Gradientstest[indexPath.row % Colors().Gradientstest.count], TextColor: Quotes!.reversed()[indexPath.row].textColor!, Number: Quotes!.reversed()[indexPath.row].number!, Type: 2)
        }else{
            
            cell.set(Text: Quotes!.reversed()[(Quotes!.count - numberofUserQuotes) + indexPath.row].text!, Author: Quotes!.reversed()[(Quotes!.count - numberofUserQuotes) + indexPath.row].author!, BackroundColor: Colors().Gradientstest.reversed()[indexPath.row % Colors().Gradientstest.count], TextColor: Quotes!.reversed()[indexPath.row].textColor!, Number: Quotes!.reversed()[(Quotes!.count - numberofUserQuotes) + indexPath.row].number!, Type: 2)
        }
        return cell
    }
    
   
    
    
}
