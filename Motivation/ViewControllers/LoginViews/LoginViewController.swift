//
//  LoginViewController.swift
//  Motivation
//
//  Created by Atahan Sahlan on 20/12/2020.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var UsernameField: UITextField!
    @IBOutlet weak var PassField: UITextField!
    @IBOutlet weak var SignInBtnOutlet: UIButton!
    @IBAction func SignInBtn(_ sender: Any) {
        if UsernameField.text != "" && PassField.text != ""{
            Auth.auth().signIn(withEmail: UsernameField.text!, password: PassField.text!) { (_: AuthDataResult?, error) in
                if error == nil{
                    database().isInitialLaunch(uid: Auth.auth().currentUser!.uid){bool in
                        if bool{
                            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "CategoryPicker") as! CategoryViewController
                            secondViewController.modalPresentationStyle = .fullScreen
                            self.present(secondViewController, animated: true) {}
                        }else{
                            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "main") as! UITabBarController
                            secondViewController.modalPresentationStyle = .fullScreen
                            self.present(secondViewController, animated: true) {}
                        }
                    }
                }
                else{
                    let alertController = UIAlertController(title: error?.localizedDescription, message: "", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default))
                    self.present(alertController, animated: true,completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.white

        makeFieldsLineOnly()
        addShadows()
        // Do any additional setup after loading the view.
    }
    func addShadows(){
        SignInBtnOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        SignInBtnOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        SignInBtnOutlet.layer.shadowOpacity = 1.0
        SignInBtnOutlet.layer.shadowRadius = 5.0
        SignInBtnOutlet.layer.masksToBounds = false
    }
    func makeFieldsLineOnly(){

        let EmailLine = CALayer()
        let PassLine = CALayer()

        EmailLine.backgroundColor = UIColor.white.cgColor
        PassLine.backgroundColor = UIColor.white.cgColor
        

        UsernameField.attributedPlaceholder = NSAttributedString(string: "Email",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray6])
        PassField.attributedPlaceholder = NSAttributedString(string: "Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray6])
                                   

        UsernameField.borderStyle = .none
        PassField.borderStyle = .none

        
        EmailLine.frame = CGRect(x: 0, y: UsernameField.frame.height - 2, width: UsernameField.frame.width, height: 2)
        UsernameField.layer.addSublayer(EmailLine)
        
        PassLine.frame = CGRect(x: 0, y: PassField.frame.height - 2, width: PassField.frame.width, height: 2)
        PassField.layer.addSublayer(PassLine)
      
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
