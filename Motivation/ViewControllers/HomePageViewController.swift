//
//  HomePageViewController.swift
//  Motivation
//
//  Created by Atahan Sahlan on 09/01/2021.
//

import UIKit
import WidgetKit

class HomePageViewController: UIViewController {


    @IBOutlet weak var MoreBtnOutlet: UIButton!
    @IBOutlet weak var ShareBtnOutlet: UIButton!
    @IBOutlet weak var FavoritesBtn: UIButton!
    @IBOutlet weak var ForYouBtn: UIButton!
    @IBOutlet weak var QuoteText: UILabel!
    @IBOutlet weak var AuthorText: UILabel!
    @IBOutlet weak var LikeBtnOutlet: UIButton!
    @IBOutlet weak var ProfileBtn: UIButton!
    @IBAction func LikeBtn(_ sender: Any) {

        if Quotes!.count > currentQuote{
        if !Quotes![currentQuote].isLiked{
        database().addUserFavoriteQuote(text: Quotes![currentQuote].text!, author: Quotes![currentQuote].author!, number: Quotes![currentQuote].number!)
        Quotes![currentQuote].isLiked = true
        }else{
            database().deleteUserFavoriteQuote(number: Quotes![currentQuote].number!)
            Quotes![currentQuote].isLiked = false
        }
        self.CheckifLiked()
        }

        
    }
    @IBAction func ShareBtn(_ sender: Any) {
        HideOrBringBackItems(isHidden: true)
        
        let data = self.view.takeScreenshot()
               let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
               UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        HideOrBringBackItems(isHidden: false)

    }
    func HideOrBringBackItems(isHidden: Bool){
        FavoritesBtn.isHidden = isHidden
        ForYouBtn.isHidden = isHidden
        LikeBtnOutlet.isHidden = isHidden
        ProfileBtn.isHidden = isHidden
        ShareBtnOutlet.isHidden = isHidden
        MoreBtnOutlet.isHidden = isHidden
    }
    @IBAction func MoreBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Is something wrong?", message: "Please Select an Option", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Report quote", style: .default , handler:{ (UIAlertAction)in
                self.nextQuote()
            }))
            
            alert.addAction(UIAlertAction(title: "Block the writer", style: .destructive , handler:{ (UIAlertAction)in
                self.nextQuote()
            }))
        
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            }))

            
            //uncomment for iPad Support
            alert.popoverPresentationController?.sourceView = self.view

            self.present(alert, animated: true, completion: {
            })
    }
   
    @IBAction func FavoritesClicked(_ sender: Any) {
        if isForYou{
        let AvenirLight = NSAttributedString(string: "For You", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir Light", size: 21)!])
        ForYouBtn.setAttributedTitle(AvenirLight, for: .normal)
        let AvenirMedium = NSAttributedString(string: "Favorites", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir Medium", size: 21)!])
        FavoritesBtn.setAttributedTitle(AvenirMedium, for: .normal)
        
        getFavoriteQuotes()
        isForYou.toggle()
        }
        
//        ForYouBtn.titleLabel!.font =  UIFont(name: "Avenir Light", size: 21)
//        FavoritesBtn.titleLabel!.font =  UIFont(name: "Avenir Medium", size: 21)
//        ForYouBtn.titleLabel!.textColor = .white
//        FavoritesBtn.titleLabel!.textColor = .gray

    }
    @IBAction func ForYouClicked(_ sender: Any) {
        if !isForYou{
        let AvenirLight = NSAttributedString(string: "Favorites", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir Light", size: 21)!])
        FavoritesBtn.setAttributedTitle(AvenirLight, for: .normal)
        let AvenirMedium = NSAttributedString(string: "For You", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir Medium", size: 21)!])
        ForYouBtn.setAttributedTitle(AvenirMedium, for: .normal)
        
        getQuotes()
        isForYou.toggle()
        }

//        FavoritesBtn.titleLabel!.font =  UIFont(name: "Avenir Light", size: 21)
//        ForYouBtn.titleLabel!.font =  UIFont(name: "Avenir Medium", size: 21)
//        ForYouBtn.titleLabel!.textColor = .gray
//        FavoritesBtn.titleLabel!.textColor = .white

    }
    @IBOutlet weak var panView: UIView!

    var viewCenter: CGPoint!
    var AuthorTextCenter: CGPoint!

    var isForYou = true
    var Quotes: [Quote]?
    var currentQuote = 0
    let userDefaults = UserDefaults(suiteName: "group.Sahlan.Motivation")
    var backgroundColourIndex = 0
    var gradientCount = 0
    
    var favoriteQuotes: [String]?
    var favoriteAuthors: [String]?
    
    var UserQuotesText: [String]?
    var UserQuotesAuthor: [String]?
    var numberofUserQuotes = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragView)))
        view.gradientBackground(from: Colors().BackroundGradient1a, to: Colors().BackroundGradient1b, direction: .topleftToBottomright, index: 0)

       getQuotes()
        viewCenter = QuoteText.center
        AuthorTextCenter = AuthorText.center

        QuoteText.numberOfLines = 10
        QuoteText.font = QuoteText.font.withSize(70)
        QuoteText.adjustsFontSizeToFitWidth = true
        QuoteText.minimumScaleFactor = 0.3
        
        FavoritesBtn.titleLabel!.font =  UIFont(name: "Avenir Light", size: 21)
        ForYouBtn.titleLabel!.font =  UIFont(name: "Avenir Medium", size: 21)
        ForYouBtn.titleLabel!.textColor = .gray
        FavoritesBtn.titleLabel!.textColor = .white
       // view = BackgroundGradientView

        // Do any additional setup after loading the view.
    }
    @objc func dragView(gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: self.view)

            switch gesture.state {
            
                //viewCenter = target.center
            
            case .changed:
                QuoteText.center = CGPoint(x: viewCenter!.x, y: viewCenter!.y + translation.y)
                AuthorText.center = CGPoint(x: AuthorText.center.x, y: AuthorTextCenter.y + translation.y)

            case .ended:
                
                if translation.y > 50{
                    previousQuote()
                }
                if translation.y < -50{
                    nextQuote()

                }
                //QuoteText.center = viewCenter
                
            default: break
            }
        }
    func changeBackgroundGradient(increase: Bool){
        if increase{
            if backgroundColourIndex == 4{
                backgroundColourIndex = 0
            }else{
                backgroundColourIndex += 1

            }
            
        }else{
            if backgroundColourIndex == 0{
                backgroundColourIndex = 4
            }else{
                backgroundColourIndex -= 1
            }

        }
        gradientCount += 1
        switch backgroundColourIndex{
        case 0:
            view.gradientBackground(from: Colors().BackroundGradient1a, to: Colors().BackroundGradient1b, direction: .topleftToBottomright,index: gradientCount)
        case 1:
            view.gradientBackground(from: Colors().BackroundGradient2a, to: Colors().BackroundGradient2b, direction: .topleftToBottomright,index: gradientCount)
        case 2:
            view.gradientBackground(from: Colors().BackroundGradient3a, to: Colors().BackroundGradient3b, direction: .topleftToBottomright,index: gradientCount)
        case 3:
            view.gradientBackground(from: Colors().BackroundGradient4a, to: Colors().BackroundGradient4b, direction: .topleftToBottomright,index: gradientCount)
        case 4:
            view.gradientBackground(from: Colors().BackroundGradient5a, to: Colors().BackroundGradient5b, direction: .topleftToBottomright, index: gradientCount)
            
        
        default:
            return
            //view.gradientBackground(from: Colors().BackroundGradient1a, to: Colors().BackroundGradient1b, direction: .topleftToBottomright)
        }
    }
   
    func nextQuote(){
        changeBackgroundGradient(increase: true)
        UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
            
            var quoteframe = self.QuoteText.frame
            quoteframe.origin.y -= 400
            self.QuoteText.frame = quoteframe
            
            var authorframe = self.AuthorText.frame
            authorframe.origin.y -= 400
            self.AuthorText.frame = authorframe

        }, completion: { finished in
            if self.isForYou{

            if self.currentQuote + 10 > self.Quotes?.count ?? 0{
                self.getQuotes()
                self.QuoteText.center = self.viewCenter
                self.AuthorText.center = self.AuthorTextCenter
            }
            else{
                self.currentQuote += 1
                self.QuoteText.text = self.Quotes![self.currentQuote].text
                self.AuthorText.text = self.Quotes![self.currentQuote].author
                self.QuoteText.center = self.viewCenter
                self.AuthorText.center = self.AuthorTextCenter
                self.CheckifLiked()
            }
            }else{
            

                if self.currentQuote == self.Quotes!.count-1{
                    self.QuoteText.center = self.viewCenter
                    self.AuthorText.center = self.AuthorTextCenter
                }else{
                self.currentQuote += 1
                self.QuoteText.text = self.Quotes![self.currentQuote].text
                self.AuthorText.text = self.Quotes![self.currentQuote].author
                self.QuoteText.center = self.viewCenter
                self.AuthorText.center = self.AuthorTextCenter
                    self.CheckifLiked()
                }
            }
           
        })
    }
    func previousQuote(){
        changeBackgroundGradient(increase: false)
        UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
            
            var quoteframe = self.QuoteText.frame
            quoteframe.origin.y += 400
            self.QuoteText.frame = quoteframe
            
            var authorframe = self.AuthorText.frame
            authorframe.origin.y += 400
            self.AuthorText.frame = authorframe

        }, completion: { finished in
            if self.currentQuote == 0{
                self.QuoteText.center = self.viewCenter
                self.AuthorText.center = self.AuthorTextCenter
            }else{
            self.currentQuote -= 1
            self.QuoteText.text = self.Quotes![self.currentQuote].text
            self.AuthorText.text = self.Quotes![self.currentQuote].author
            self.QuoteText.center = self.viewCenter
            self.AuthorText.center = self.AuthorTextCenter
                self.CheckifLiked()
            }

        })
        
    }
    func getQuotes(){
        
        let alertController = UIAlertController(title: "There Is A Connection Issue", message: "Check your connection", preferredStyle: UIAlertController.Style.alert)
        
        if Reachability.isConnectedToNetwork(){
            alertController.dismiss(animated: true) {
            }
        }else{
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default))
            self.present(alertController, animated: true,completion: nil)
            
        }
        Quotes = []
        currentQuote = 0
        
        
        
        database().getQuotesForFeed { (Quotes) in
            self.Quotes = Quotes
            //print(Quotes)
            //self.Quotes?.append(contentsOf: Quotes)
            
            self.QuoteText.text = Quotes[self.currentQuote].text
            self.AuthorText.text = Quotes[self.currentQuote].author
            self.CheckifLiked()

            //self.tableView.refreshControl?.endRefreshing()
            
            self.manageNotifications()
            
            var widgetQuoteTexts: [String]?
            var widgetQuoteAuthors: [String]?
            widgetQuoteTexts = []
            widgetQuoteAuthors = []
            if Quotes.count < 48 && Quotes.count >= 1{
                for index in 0...Quotes.count-1{
                    widgetQuoteTexts?.append(Quotes[index].text!)
                    widgetQuoteAuthors?.append(Quotes[index].author!)
                    
                    if widgetQuoteAuthors!.count == 48{
                        self.userDefaults?.set(widgetQuoteTexts! as Array, forKey: "widgetQuoteTexts")
                        self.userDefaults?.set(widgetQuoteAuthors! as Array, forKey: "widgetQuoteAuthors")
                        
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }
            }else{
                if Quotes.count >= 49{
                for index in 0...48{
                    widgetQuoteTexts?.append(Quotes[index].text ?? "error")
                    widgetQuoteAuthors?.append(Quotes[index].author ?? "error")
                    
                    if widgetQuoteAuthors!.count == 48{
                        self.userDefaults?.set(widgetQuoteTexts! as Array, forKey: "widgetQuoteTexts")
                        self.userDefaults?.set(widgetQuoteAuthors! as Array, forKey: "widgetQuoteAuthors")
                        WidgetCenter.shared.reloadAllTimelines()
                        
                    }
                }
                }
            }
            
            
            
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
        currentQuote = 0
       // print(favoriteQuotes)
        if favoriteQuotes != nil && favoriteQuotes!.count > 0{
            for index in 0...favoriteQuotes!.count-1{
                Quotes?.append(Quote(Text: favoriteQuotes![index], Author: favoriteAuthors![index], Popularity: 0, Category: [""], Number: 999999))
                //print(favoriteQuotes![index])
                //Quotes = Quotes?.reversed()
                //print("buraso")

            }
            self.QuoteText.text = self.Quotes![self.currentQuote].text
            self.AuthorText.text = self.Quotes![self.currentQuote].author
            self.likeLikedQuotes()
            self.CheckifLiked()
        }else{
        favorites?.forEach{
            database().getQuote(number: $0){(quote)in
                self.Quotes?.append(quote)
                
               

                favQuotes.append(quote.text!)
                favAuthors.append(quote.author!)

    
                 self.userDefaults?.set(favQuotes as Array, forKey: "favoriteQuotes")
                 self.userDefaults?.set(favAuthors as Array, forKey: "favoriteAuthors")
               
            }
                
            }
            if self.Quotes!.count > self.currentQuote{
            self.QuoteText.text = self.Quotes![self.currentQuote].text
            self.AuthorText.text = self.Quotes![self.currentQuote].author
            self.likeLikedQuotes()
            self.CheckifLiked()
            }

        }
        database().getUserFavoriteQuotes(){ quotes in
            for quote in quotes{
                self.Quotes?.append(Quote(Text: quote.text!, Author: quote.author!, Popularity: 0, Category: [""], Number: quote.number!))

            }
            self.QuoteText.text = self.Quotes![self.currentQuote].text
            self.AuthorText.text = self.Quotes![self.currentQuote].author
            self.likeLikedQuotes()
            self.CheckifLiked()
            //print(quotes[0].text)
        }
    }
    func likeLikedQuotes(){
        for Quote in Quotes!{
            Quote.isLiked = true
        }
        
    }
   
    func CheckifLiked(){
        if self.Quotes![self.currentQuote].isLiked{
            self.LikeBtnOutlet.setBackgroundImage(UIImage(systemName:"heart.fill"), for: .normal)
        }else{
            self.LikeBtnOutlet.setBackgroundImage(UIImage(systemName:"heart"), for: .normal)
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        view.gradientBackground(from: Colors().color1, to: Colors().color2, direction: .topleftToBottomright)
//    }
    func manageNotifications(){
        DispatchQueue.main.async {
            
            let startMinuteString = self.userDefaults?.string(forKey: "reminderStartMinuteString") ?? "00"
            let endMinuteString = self.userDefaults?.string(forKey: "reminderEndMinuteString") ?? "00"
            var startHour = self.userDefaults?.integer(forKey: "reminderStartHourInt") ?? 10
            var endHour = self.userDefaults?.integer(forKey: "reminderEndHourInt") ?? 22
            let amount = self.userDefaults?.integer(forKey: "reminderAmount") ?? 10
            
            if startHour == 0  && amount == 0{
                startHour = 10
                endHour = 22
                //amount = 10
            }
            if startHour == 0{
                startHour = 10
            }
            if endHour == 0{
                endHour = 22
            }
            
            //        print(startMinuteString)
            //        print(endMinuteString)
            //        print(startHour)
            //        print(endHour)
            //        print(amount)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
            center.removeAllPendingNotificationRequests()
            if amount != 0{
                if self.Quotes!.count/amount >= 1{
                    //print(amount)
                    for day in 1...self.Quotes!.count/amount{
                        for index in 1...amount{
                            let content = UNMutableNotificationContent()
                            if self.Quotes!.count > index*day{
                                content.title = self.Quotes![index*day].author ?? "error"
                                content.body = self.Quotes![index*day].text ?? "error"
                                
                                content.sound = UNNotificationSound.default
                                content.categoryIdentifier = "Mindful"
                                content.userInfo = [self.Quotes![index*day].author ?? "error": self.Quotes![index*day].text ?? "error"] // You can retrieve this when displaying notification
                            }
                            let today = Date()
                            var calendar = Calendar.current
                            calendar.timeZone = TimeZone.current
                            let components = calendar.dateComponents([.day, .month, .year], from: today)
                            
                            var dateComp:DateComponents = DateComponents()
                            dateComp.day = components.day!+day-1
                            dateComp.month = components.month
                            dateComp.year = components.year
                            dateComp.hour = startHour
                            dateComp.minute = Int(startMinuteString)
                            
                            var dateComp2:DateComponents = DateComponents()
                            if endHour < startHour{
                                dateComp2.day = components.day!+day
                            }else{
                                dateComp2.day = components.day!+day-1
                            }
                            dateComp2.month = components.month
                            dateComp2.year = components.year
                            dateComp2.hour = endHour
                            dateComp2.minute = Int(endMinuteString)
                            
                            
                            let dateDelta = calendar.date(from: dateComp2)! - calendar.date(from: dateComp)!
                            let triggerDate = calendar.date(from: dateComp)! + (Double(index) * (dateDelta / Double(amount)))
                            let triggerDateComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: triggerDate)
                            //print(dateDelta/Double(amount))
                            //let date = calendar.date(from: dateComp)
                            // Setup trigger time
                            
                            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
                            
                            //  print(trigger)
                            // Create request
                            let uniqueID = UUID().uuidString // Keep a record of this if necessary
                            let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
                            center.add(request){ (error) in
                                if let error = error {
                                    print("Error \(error.localizedDescription)")
                                }
                            }
                            //            print(center.getPendingNotificationRequests(completionHandler: { error in
                            //                print(error)
                            //                    // error handling here
                            //                }))
                        }
                    }
                }
            }
            // Add the notification request
        }
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
extension UIView {
    enum GradientDirection {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
        case topleftToBottomright
    }
    func gradientBackground(from color1: UIColor, to color2: UIColor, direction: GradientDirection, index: Int) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color1.cgColor, color2.cgColor]

        switch direction {
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .topleftToBottomright:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        default:
            break
        }
       // self.layer.replaceSublayer(self.layer.sublayers![0], with: gradient)
        //self.layer.insertSublayer(gradient, below: self.layer)
        if index != 0{
            self.layer.sublayers?.first?.removeFromSuperlayer()

        }
        self.layer.insertSublayer(gradient, at: 0)

       // self.layer.insertSublayer(gradient, at: UInt32(CGFloat(index)*CGFloat(0.1)))
    }
}
