//
//  WelcomePageViewController.swift
//  Motivation
//
//  Created by Atahan Sahlan on 30/12/2020.
//

import UIKit

class WelcomePageViewController: UIViewController {
    
    
    @IBOutlet weak var CreateAccountBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShadows()
        //UIColor(CGGradient)
       // view.backgroundColor = .blue //Colors().BackroundGradient
        
        
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.colors = [hexStringToUIColor(hex: "C7EC86"), hexStringToUIColor(hex: "5CDEBB")]
//        gradient.colors = 
//        gradient.locations = [0.0, 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
//       
//        
//        //var backroundLayer = Colors().BackroundGradient
//        view.layer.insertSublayer(gradient, at: 0)
        // Do any additional setup after loading the view.
    }
    func addShadows(){
        CreateAccountBtnOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        CreateAccountBtnOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        CreateAccountBtnOutlet.layer.shadowOpacity = 1.0
        CreateAccountBtnOutlet.layer.shadowRadius = 5.0
        CreateAccountBtnOutlet.layer.masksToBounds = false
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
