//
//  CategoryViewController.swift
//  Motivation
//
//  Created by Atahan Sahlan on 23/12/2020.
//

import UIKit
import SwiftUI

class CategoryViewController: UIViewController {
    var  categoryPickerView = UIHostingController(rootView: CategoryPickerView())
    

    override func viewDidLoad() {
        super.viewDidLoad()
    //    navigationController?.pushViewController(categoryPickerView, animated: true)
       addChild(categoryPickerView)
        view.addSubview(categoryPickerView.view)

        categoryPickerView.view.translatesAutoresizingMaskIntoConstraints = false
        categoryPickerView.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        categoryPickerView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        categoryPickerView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0).isActive = true
        categoryPickerView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0).isActive = true

        // Do any additional setcup after loading the view.
    }
    func doneSelecting(){
        //categoryPickerView.removeFromParent()
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "main") as! UITabBarController
        secondViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(secondViewController, animated: true)
        //self.present(secondViewController, animated: true) {}
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
