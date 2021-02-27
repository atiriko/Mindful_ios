//
//  SettingsViewController.swift
//  Motivation
//
//  Created by Atahan Sahlan on 13/10/2020.
//

import UIKit
import SwiftUI
import Firebase
//  widget
//share
//collections
//  add your own
//search
//  favorites
//past quotes




class SettingsViewController: UIViewController {
    var  categoryPickerView = UIHostingController(rootView: CategoryPickerView())
  

    @IBAction func SignOutBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure you want to sign out?", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: { (UIAlertAction) in
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default))
        self.present(alertController, animated: true,completion: nil)
        
   
        
    }
    var handle: AuthStateDidChangeListenerHandle?
    let userDefaults = UserDefaults(suiteName: "group.Sahlan.Motivation")
    
    var categoriesBtn = UIButton()

    var notificationSheduleView = UIHostingController(rootView: NotificationSheduleView())

    @IBAction func PremiumBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "Coming Very Soon!", message: "We'll let you know when it arrives.", preferredStyle: UIAlertController.Style.alert)

            alertController.addAction(UIAlertAction(title: "Cool", style: UIAlertAction.Style.default))
    self.present(alertController, animated: true,completion: nil)
    }
    @IBAction func NotificationSwitch(_ sender: Any) {
        notificationSheduleView.view.isHidden = !notificationSheduleView.view.isHidden
        
        if notificationSheduleView.view.isHidden{
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

            
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
            center.removeAllPendingNotificationRequests()
            
            userDefaults?.set(0, forKey: "reminderAmount")
        }
    }
    @IBOutlet weak var dailynotText: UILabel!
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil{
             let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "signUp") as! UINavigationController
            secondViewController.modalPresentationStyle = .fullScreen
            self.present(secondViewController, animated: true) {}
            }
        }
        database().getUserFavoriteCategories(){Categories in
            self.categoryPickerView = UIHostingController(rootView: CategoryPickerView(SelectedCategories: Categories))
        }
//        let startMinuteString = userDefaults?.string(forKey: "reminderStartMinuteString") ?? "00"
//        let endMinuteString = userDefaults?.string(forKey: "reminderEndMinuteString") ?? "00"
//        let startHour = userDefaults?.integer(forKey: "reminderStartHourInt") ?? 10
//        let endHour = userDefaults?.integer(forKey: "reminderEndHourInt") ?? 22
//        let amount = userDefaults?.integer(forKey: "reminderAmount") ?? 10
//        notificationSheduleView = UIHostingController(rootView: NotificationSheduleView(Amount: amount, StartHour: startHour, StartMinuteString: startMinuteString, EndHour: endHour, EndMinuteString: endMinuteString))
        view.addSubview(categoriesBtn)
        addChild(notificationSheduleView)
        view.addSubview(notificationSheduleView.view)
   
        addConstraints()
        categoriesBtn.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    @objc func buttonClicked(){
        categoryPickerView.modalPresentationStyle = .formSheet
        self.present(categoryPickerView, animated: true) {
            
        }
    }
    func addConstraints(){
        notificationSheduleView.view.translatesAutoresizingMaskIntoConstraints = false
        notificationSheduleView.view.widthAnchor.constraint(equalToConstant: 316).isActive = true
        notificationSheduleView.view.heightAnchor.constraint(equalToConstant: 146).isActive = true
        
        notificationSheduleView.view.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -20).isActive = true
        notificationSheduleView.view.topAnchor.constraint(equalTo: dailynotText.bottomAnchor, constant: 20).isActive = true
        
        notificationSheduleView.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        
        categoriesBtn.translatesAutoresizingMaskIntoConstraints = false
        categoriesBtn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        categoriesBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        categoriesBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        categoriesBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true
//        categoriesBtn.backgroundColor = .systemBlue
//        categoriesBtn.layer.cornerRadius = 25
        categoriesBtn.setTitle("Categories", for: .normal)
        categoriesBtn.setTitleColor(.systemBlue, for: .normal)
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
struct MyInjector: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<MyInjector>) -> SettingsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let settingsVC = storyboard.instantiateViewController(identifier: "Settings") as! SettingsViewController
                return settingsVC
        //SettingsViewController()
    }

    func updateUIViewController(_ uiViewController: SettingsViewController, context: UIViewControllerRepresentableContext<MyInjector>) {
    }
}
