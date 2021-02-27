//
//  FeedViewController.swift
//  Motivation
//
//  Created by Atahan Sahlan on 06/11/2020.
//

import UIKit
import WidgetKit
import GoogleMobileAds


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADInterstitialDelegate{
    
    let userDefaults = UserDefaults(suiteName: "group.Sahlan.Motivation")
    
    @IBOutlet weak var tableView: UITableView!
    
    var Quotes: [Quote]?
    
    var refreshControl = UIRefreshControl()
    var addBtn = UIButton()
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if  UserDefaults.isFirstLaunch(){
            userDefaults?.set(10, forKey: "reminderAmount")
            
        }
        interstitial = createAndLoadInterstitial()


       // interstitial = GADInterstitial(adUnitID: "ca-app-pub-2092620769473230/7339169474")
        let request = GADRequest()
        interstitial.load(request)
        configureTableView()
        
        configureBtn()
        configureRefreshControl()
       
        getQuotes()

       
        // Do any additional setup after loading the view.
    }
    func createAndLoadInterstitial() -> GADInterstitial {
        //real: ca-app-pub-2092620769473230/7339169474
        //test: ca-app-pub-3940256099942544/4411468910
      let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2092620769473230/7339169474")
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createAndLoadInterstitial()
    }
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
    func computeNewDate(from fromDate: Date, to toDate: Date) -> Date{
        let delta = toDate - fromDate // `Date` - `Date` = `TimeInterval`
        let today = Date()
        if delta < 0 {
            return today
        } else {
            return today + delta // `Date` + `TimeInterval` = `Date`
        }
    }
    func configureBtn(){
        // addBtn.setBackgroundImage(UIImage(named: "plus"), for: UIControl.State.normal)
        let tintedImage = UIImage(named: "plus")!.withRenderingMode(.alwaysTemplate)
        addBtn.setImage(tintedImage, for: .normal)
        addBtn.tintColor = .systemBlue
        addBtn.backgroundColor = .white
        self.view.addSubview(addBtn)
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
        addBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        addBtn.layer.cornerRadius = 25
        
        addBtn.layer.shadowColor = UIColor.lightGray.cgColor
        addBtn.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        addBtn.layer.shadowOpacity = 1.0
        addBtn.layer.shadowRadius = 5.0
        addBtn.layer.masksToBounds = false
        addBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
        
    }
    @objc func buttonAction(sender: UIButton!) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let addQuoteViewController = mainStoryboard.instantiateViewController(withIdentifier: "AddQuoteView2") as! UINavigationController
        
        self.present(addQuoteViewController, animated: true, completion: nil)
        //        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        var pvc = storyboard.instantiateViewController(withIdentifier: "AddQuoteView") as! AddQuoteViewController
        //
        //        pvc.modalPresentationStyle = UIModalPresentationStyle.custom
        //                pvc.transitioningDelegate = self
        //       // pvc.view.backgroundColor = UIColor.redColor
        //
        //        self.present(pvc, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        tableView.reloadData()
    }
    
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
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
        //tableView.refreshControl?.beginRefreshing()

        // tableView.addSubview(refreshControl)
    }
    
    @objc func handleRefreshControl() {
        //Quotes = []

        getQuotes()
        
        
        
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func getQuotes(){
       //     self.tableView.refreshControl?.beginRefreshing()
        
        
        let alertController = UIAlertController(title: "There Is A Connection Issue", message: "Check your connection", preferredStyle: UIAlertController.Style.alert)
        
        if Reachability.isConnectedToNetwork(){
            alertController.dismiss(animated: true) {
            }
        }else{
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default))
            self.present(alertController, animated: true,completion: nil)
            
        }
        Quotes = []
        
        
        
        database().getQuotesForFeed { (Quotes) in
            self.Quotes = Quotes
            //print(Quotes)
            //self.Quotes?.append(contentsOf: Quotes)
            self.tableView.reloadData()
            
            self.tableView.refreshControl?.endRefreshing()
            
           
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
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Quotes != nil{
            
            return Quotes!.count
            
        }else{
            return 0
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetCell") as! FavoritesTableViewCell
        if indexPath.row > 15{
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                //print("Ad wasn't ready")
            }
        }
      
        if Quotes!.count > indexPath.row{
            if Quotes![indexPath.row].text != nil{
                cell.set(Text: Quotes![indexPath.row].text!, Author: Quotes![indexPath.row].author!, BackroundColor: Colors().Gradientstest[indexPath.row % Colors().Gradientstest.count], TextColor: Quotes![indexPath.row].textColor!, Number: Quotes![indexPath.row].number!, Type: 1)
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // need to pass your indexpath then it showing your indicator at bottom
        tableView.addLoading(indexPath) {
            
            database().loadMoreQuotesForFeed { (Quotes) in
                // self.Quotes = Quotes
                self.Quotes?.append(contentsOf: Quotes)
                
                self.tableView.reloadData()
                self.tableView.stopLoading() // stop your indicator
                
                
            }
            // add your code here
            // append Your array and reload your tableview
        }
        
    }
    //
    //    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { [self]  (contextualAction, view, boolValue) in
    //
    //            //self.Quotes![indexPath.row].number
    //
    //        }
    //
    //        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
    //
    //        return swipeActions
    //
    //    }
    //
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UITableView{
    
    func indicatorView() -> UIActivityIndicatorView{
        var activityIndicatorView = UIActivityIndicatorView()
        if self.tableFooterView == nil{
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 40)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.isHidden = false
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            activityIndicatorView.isHidden = true
            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        }else{
            return activityIndicatorView
        }
    }
    
    func addLoading(_ indexPath:IndexPath, closure: @escaping (() -> Void)){
        indicatorView().startAnimating()
        if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    closure()
                }
            }
        }
        indicatorView().isHidden = false
    }
    
    func stopLoading(){
        indicatorView().stopAnimating()
        indicatorView().isHidden = true
    }
}
extension Date {
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
}
extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    // Note: Store this value in AppDelegate if you have multiple places where you are checking for this flag
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}

