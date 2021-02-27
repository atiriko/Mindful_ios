//
//  TabbarController.swift
//  Motivation
//
//  Created by Atahan Sahlan on 29/12/2020.
//

import UIKit
import Firebase


class TabbarController: UITabBarController ,UITabBarControllerDelegate{
    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var TabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
    //    self.UITabBar.setTransparentTabbar()
        if selectedIndex == 0{
            UITabBar.appearance().backgroundColor = UIColor.clear
        }else{
            UITabBar.appearance().backgroundColor = UIColor.white
        }
      //  UITabBar().backgroundImage = UIImage()
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
          // ...
            if auth.currentUser != nil{
                database().isInitialLaunch(uid: Auth.auth().currentUser!.uid){bool in
                    if bool{
                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "CategoryPicker") as! CategoryViewController
                        secondViewController.modalPresentationStyle = .fullScreen
                        self.present(secondViewController, animated: true)
                    }else{
                        
                    }
                }
            }else{
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "signUp") as! UINavigationController
                secondViewController.modalPresentationStyle = .fullScreen
                self.present(secondViewController, animated: true) {}
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.selectedIndex = 4
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

extension UITabBar {


static func setTransparentTabbar() {
  UITabBar.appearance().backgroundImage = UIImage()
  UITabBar.appearance().shadowImage     = UIImage()
  UITabBar.appearance().clipsToBounds   = true
 }
static func reverseTransparentTabbar() {
    UITabBar.appearance().backgroundImage = UIImage()
      UITabBar.appearance().shadowImage     = UIImage()
      UITabBar.appearance().clipsToBounds   = true
     }
}
