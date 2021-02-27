//
//  ForgotPassViewController.swift
//  Motivation
//
//  Created by Atahan Sahlan on 20/12/2020.
//

import UIKit
import Firebase

class ForgotPassViewController: UIViewController {

 
    @IBAction func CancelBtn(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    @IBOutlet weak var EmailField: UITextField!
    
    @IBOutlet weak var SendBtnOutlet: UIButton!
    @IBAction func sendBtn(_ sender: Any) {
        if EmailField.text != ""{
            Auth.auth().sendPasswordReset(withEmail: EmailField.text!) { (error) in
                print(error?.localizedDescription)
                if error == nil{
                    
                }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
       
        addShadows()
        makeFieldsLineOnly()
        // Do any additional setup after loading the view.
    }
    func addShadows(){
        SendBtnOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        SendBtnOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        SendBtnOutlet.layer.shadowOpacity = 1.0
        SendBtnOutlet.layer.shadowRadius = 5.0
        SendBtnOutlet.layer.masksToBounds = false
    }
    func makeFieldsLineOnly(){

        let EmailLine = CALayer()

        EmailLine.backgroundColor = UIColor.white.cgColor
        

        EmailField.attributedPlaceholder = NSAttributedString(string: "Email",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray6])

                                   

        EmailField.borderStyle = .none

        
        EmailLine.frame = CGRect(x: 0, y: EmailField.frame.height - 2, width: EmailField.frame.width, height: 2)
        EmailField.layer.addSublayer(EmailLine)

      
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
