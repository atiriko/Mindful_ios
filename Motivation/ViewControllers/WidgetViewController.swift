//
//  ViewController.swift
//  Motivation
//
//  Created by Atahan Sahlan on 01/10/2020.
//

import UIKit
import WidgetKit
import SwiftUI
import GoogleMobileAds


class ViewController: UIViewController, GADRewardedAdDelegate, UIFontPickerViewControllerDelegate, UIColorPickerViewControllerDelegate {
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print(reward)
    }
    
    var Quote: Quote?
    let backgroundColorPicker = UIHostingController(rootView: ColorPickerView(Text: "Backround Color"))
    let textColorPicker = UIHostingController(rootView: ColorPickerView(Text: "Text Color"))
    var  widgetView = UIHostingController(rootView: WidgetView( Number: 0, Type: 1))
    var refreshControl = UIRefreshControl()
    var rewardedAd: GADRewardedAd?
    let picker = UIColorPickerViewController()
let backgroundColorPickerButton = UIButton()
    let textColorPickerButton = UIButton()

   
    @IBAction func SettingsBtn(_ sender: Any) {
//        let alertController = UIAlertController(title: "Local Notification", message: nil, preferredStyle: .actionSheet)
//               let setLocalNotificationAction = UIAlertAction(title: "Set", style: .default) { (action) in
//                   LocalNotificationManager.setNotification(5, of: .seconds, repeats: false, title: "Hello", body: "local", userInfo: ["aps" : ["hello" : "world"]])
//               }
//               let removeLocalNotificationAction = UIAlertAction(title: "Remove", style: .default) { (action) in
//                   LocalNotificationManager.cancel()
//               }
//               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
//               alertController.addAction(setLocalNotificationAction)
//               alertController.addAction(removeLocalNotificationAction)
//               alertController.addAction(cancelAction)
//               self.present(alertController, animated: true, completion: nil)
        
    }
    let userDefaults = UserDefaults(suiteName: "group.Sahlan.Motivation")
  
    @IBOutlet weak var ChangeFontBtn: UIButton!
    @IBAction func AdBtn(_ sender: Any) {
        if rewardedAd?.isReady == true {
              rewardedAd?.present(fromRootViewController: self, delegate:self)
            rewardedAd?.load(GADRequest())

            
           }
        else{
            rewardedAd?.load(GADRequest())

            let alertController = UIAlertController(title: "There Aren't Any Ads To Show", message: "Try Again Later", preferredStyle: UIAlertController.Style.alert)

            
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default))
        self.present(alertController, animated: true,completion: nil)
        }
                
        
    }
    @IBAction func ChangeFontButton(_ sender: Any) {
        let vc = UIFontPickerViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    @IBAction func Button(_ sender: Any) {

        let bcolor = CGColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
        let color = Color(bcolor)
        let backgroundcolor = Gradient(colors: [color, color])
  
        getPreferedColorsFromUserDefaults()
        getQuote()
        widgetView.removeFromParent()
        widgetView = UIHostingController(rootView: WidgetView(Text: quoteText,Author: quoteAuthor,TextColor:UIColor(red: CGFloat(rt), green: CGFloat(gt), blue: CGFloat(bt), alpha: 1) , BackroundColor: backgroundcolor, Number: Quote?.number, Type: 1))
        addChild(widgetView)
        view.addSubview(widgetView.view)
        addConstrains()

        WidgetCenter.shared.reloadAllTimelines()

        

        
    }
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var AuthorText: UILabel!
    @IBOutlet weak var QuoteText: UILabel!
    var quoteText: String?
    var quoteAuthor: String?
    var quoteImage: UIImage?
    var quoteImageColor: UIColor?
    var r: Float = 0
    var g: Float = 0
    var b: Float = 0
    var rt: Float = 1
    var gt: Float = 1
    var bt: Float = 1
    var istext: Bool?
    
   
    @IBAction func swipeGesture(_ sender: Any) {
        getQuote()
    }
    
    
    let backroundgr = Gradient(colors: [.red, .white])

    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-2092620769473230/6943913225")
        rewardedAd?.load(GADRequest())
        getQuote()
 
        
        getPreferedColorsFromUserDefaults()
        picker.delegate = self
        picker.supportsAlpha = false
//        addChild(backgroundColorPicker)
//        view.addSubview(backgroundColorPicker.view)
//        addChild(textColorPicker)
//        view.addSubview(textColorPicker.view)
        view.addSubview(backgroundColorPickerButton)
        backgroundColorPickerButton.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        view.addSubview(textColorPickerButton)
        textColorPickerButton.addTarget(self, action:#selector(self.textColorButtonClicked), for: .touchUpInside)
        

        configueButtons()
        let bcolor = CGColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
        let color = Color(bcolor)
        let backgroundcolor = Gradient(colors: [color, color])
        
        widgetView = UIHostingController(rootView: WidgetView(Text: quoteText,Author: quoteAuthor,TextColor:UIColor(red: CGFloat(rt), green: CGFloat(gt), blue: CGFloat(bt), alpha: 1) , BackroundColor: backgroundcolor, Number: Quote?.number, Type: 1))
      //  addChild(widgetView)
        view.addSubview(widgetView.view)
        addConstrains()

      
    }
   // textColorButtonClicked
    @objc func textColorButtonClicked(sender: UIButton!) {
        istext = true
        self.present(picker, animated: true, completion: nil)
    }
    @objc func buttonClicked(sender: UIButton!) {
        istext = false
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func pickColor(_ sender: Any) {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        
        picker.selectedColor = self.view.backgroundColor ?? UIColor.black
        self.present(picker, animated: true, completion: nil)
    }
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        if (istext!){
            
            userDefaults?.set(  viewController.selectedColor.cgColor.components![0], forKey: "TextColorR")
            userDefaults?.set(  viewController.selectedColor.cgColor.components![1], forKey: "TextColorG")
            userDefaults?.set(  viewController.selectedColor.cgColor.components![2], forKey: "TextColorB")
        }else{
            userDefaults?.set(  viewController.selectedColor.cgColor.components![0], forKey: "ColorR")
            userDefaults?.set(  viewController.selectedColor.cgColor.components![1], forKey: "ColorG")
            userDefaults?.set(  viewController.selectedColor.cgColor.components![2], forKey: "ColorB")
        }
       // self.view.backgroundColor = viewController.selectedColor
        let bcolor = CGColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
        let color = Color(bcolor)
        let backgroundcolor = Gradient(colors: [color, color])
        widgetView.removeFromParent()

        getPreferedColorsFromUserDefaults()
        getQuote()
        widgetView = UIHostingController(rootView: WidgetView(Text: quoteText,Author: quoteAuthor,TextColor:UIColor(red: CGFloat(rt), green: CGFloat(gt), blue: CGFloat(bt), alpha: 1) , BackroundColor: backgroundcolor, Number: Quote?.number, Type: 1))
//        addChild(widgetView)
//        view.addSubview(widgetView.view)
//        addConstrains()
//
        WidgetCenter.shared.reloadAllTimelines()
        viewController.dismiss(animated: true, completion: nil)
    }
    func configueButtons(){
        backgroundColorPickerButton.setTitle("Background Color", for: .normal)
        backgroundColorPickerButton.titleLabel?.textColor = .white
        backgroundColorPickerButton.backgroundColor = .systemBlue
        backgroundColorPickerButton.layer.cornerRadius = 20
        textColorPickerButton.setTitle("Text Color", for: .normal)
        textColorPickerButton.titleLabel?.textColor = .white
        textColorPickerButton.backgroundColor = .systemBlue
        textColorPickerButton.layer.cornerRadius = 20
    }
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        // attempt to read the selected font descriptor, but exit quietly if that fails
        guard let descriptor = viewController.selectedFontDescriptor else { return }

        let font = UIFont(descriptor: descriptor, size: 36)
        
        userDefaults?.set(font.fontName, forKey: "FavoriteFont")
        widgetView.removeFromParent()

        getPreferedColorsFromUserDefaults()
        getQuote()
//        addChild(widgetView)
//        view.addSubview(widgetView.view)
//        addConstrains()
//
        WidgetCenter.shared.reloadAllTimelines()

        //print(font)

    }
   
    func getPreferedColorsFromUserDefaults(){
        r = userDefaults?.float(forKey: "ColorR") ?? 0
        g = userDefaults?.float(forKey: "ColorG") ?? 0
        b = userDefaults?.float(forKey: "ColorB") ?? 0
        
        rt = userDefaults?.float(forKey: "TextColorR") ?? 1
        gt = userDefaults?.float(forKey: "TextColorG") ?? 1
        bt = userDefaults?.float(forKey: "TextColorB") ?? 1
      
        
        if(r == rt){
            rt = 1-rt
        }
        if(g == gt){
            gt = 1-gt
        }
        if(b == bt){
            bt = 1-bt
        }


    }
    fileprivate func addConstrains(){
        //WidgetView Constraints
        widgetView.view.translatesAutoresizingMaskIntoConstraints = false

        widgetView.view.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90).isActive = true
        widgetView.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width/2-316/2).isActive = true
        widgetView.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
      

        //Backround Color Picker Constraints (view.frame.width/2)-(widgetView.view.frame.width))
        backgroundColorPickerButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundColorPickerButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        backgroundColorPickerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backgroundColorPickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundColorPickerButton.topAnchor.constraint(equalTo: widgetView.view.bottomAnchor,constant: 120).isActive = true
        backgroundColorPickerButton.layer.shadowColor = UIColor.lightGray.cgColor
        backgroundColorPickerButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        backgroundColorPickerButton.layer.shadowOpacity = 1.0
        backgroundColorPickerButton.layer.shadowRadius = 5.0
        backgroundColorPickerButton.layer.masksToBounds = false
        
        
        textColorPickerButton.translatesAutoresizingMaskIntoConstraints = false
        textColorPickerButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textColorPickerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textColorPickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textColorPickerButton.topAnchor.constraint(equalTo: backgroundColorPickerButton.bottomAnchor,constant: 25).isActive = true
        textColorPickerButton.layer.shadowColor = UIColor.lightGray.cgColor
        textColorPickerButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        textColorPickerButton.layer.shadowOpacity = 1.0
        textColorPickerButton.layer.shadowRadius = 5.0
        textColorPickerButton.layer.masksToBounds = false
        
        
//
//        backgroundColorPicker.view.translatesAutoresizingMaskIntoConstraints = false
//        backgroundColorPicker.view.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        backgroundColorPicker.view.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        backgroundColorPicker.view.topAnchor.constraint(equalTo: widgetView.view.bottomAnchor, constant: 25).isActive = true
//        backgroundColorPicker.view.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
//        backgroundColorPicker.view.layer.shadowColor = UIColor.lightGray.cgColor
//       backgroundColorPicker.view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        backgroundColorPicker.view.layer.shadowOpacity = 0.5
//       backgroundColorPicker.view.layer.shadowRadius = 5.0
//        backgroundColorPicker.view.layer.masksToBounds = false
//        backgroundColorPicker.view.layer.cornerRadius = 20
        //Text Color Picker Constraints
//        textColorPicker.view.translatesAutoresizingMaskIntoConstraints = false
//        textColorPicker.view.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        textColorPicker.view.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        textColorPicker.view.topAnchor.constraint(equalTo: backgroundColorPicker.view.bottomAnchor, constant: 25).isActive = true
//        textColorPicker.view.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive = true
//        textColorPicker.view.layer.shadowColor = UIColor.lightGray.cgColor
//        textColorPicker.view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        textColorPicker.view.layer.shadowOpacity = 0.5
//        textColorPicker.view.layer.shadowRadius = 5.0
//        textColorPicker.view.layer.masksToBounds = false
//        textColorPicker.view.layer.cornerRadius = 20
//        textColorPicker.view.translatesAutoresizingMaskIntoConstraints = false
//        textColorPicker.view.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        textColorPicker.view.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        textColorPicker.view.topAnchor.constraint(equalTo: backgroundColorPicker.view.bottomAnchor, constant: 10).isActive = true
//        textColorPicker.view.leftAnchor.constraint(equalTo:view.leftAnchor ,constant:75 ).isActive = true
        ChangeFontBtn.topAnchor.constraint(equalTo: textColorPickerButton.bottomAnchor, constant: 25).isActive = true
        ChangeFontBtn.backgroundColor = .systemBlue
        ChangeFontBtn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        ChangeFontBtn.layer.shadowColor = UIColor.lightGray.cgColor
        ChangeFontBtn.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        ChangeFontBtn.layer.shadowOpacity = 1.0
        ChangeFontBtn.layer.shadowRadius = 5.0
        ChangeFontBtn.layer.masksToBounds = false


    }
 
    
    func getQuote(){
        let alertController = UIAlertController(title: "There Is A Connection Issue", message: "Check your connection", preferredStyle: UIAlertController.Style.alert)

        if Reachability.isConnectedToNetwork(){
            alertController.dismiss(animated: true) {
            }
        }else{
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default))
    self.present(alertController, animated: true,completion: nil)
            
        }
        quoteText = ""
        quoteAuthor = ""

        let number = Int.random(in: 0..<Variables().NumberOfQuotesAtDatabase)


        database().getQuote(number: number){(quote)in
            self.quoteText = quote.text
            self.quoteAuthor = quote.author
            UIView.animate(withDuration: 0.0, delay: 0, options: .curveEaseOut, animations: {
//                self.widgetView.view.isHidden = false
//
//
//                self.widgetView.removeFromParent()
//
//                var widgetViewFrame = self.widgetView.view.frame
//                widgetViewFrame.origin.x += 50
//                self.widgetView.view.frame = widgetViewFrame
              
    //          var fabricBottomFrame = self.fabricBottom.frame
    //          fabricBottomFrame.origin.y += fabricBottomFrame.size.height
    //
    //          self.fabricTop.frame = fabricTopFrame
    //          self.fabricBottom.frame = fabricBottomFrame
            }, completion: { finished in
                let bcolor = CGColor(red: CGFloat(self.r), green: CGFloat(self.g), blue: CGFloat(self.b), alpha: 1)
                let color = Color(bcolor)
                let backgroundcolor = Gradient(colors: [color, color])
           self.widgetView.removeFromParent()

                self.widgetView = UIHostingController(rootView: WidgetView(Text: self.quoteText,Author: self.quoteAuthor,TextColor:UIColor(red: CGFloat(self.rt), green: CGFloat(self.gt), blue: CGFloat(self.bt), alpha: 1) , BackroundColor: backgroundcolor, Number: quote.number, Type: 1))
//                self.addChild(self.widgetView)
                self.view.addSubview(self.widgetView.view)
                

                self.addConstrains()
                WidgetCenter.shared.reloadAllTimelines()

            })
            
        
    }

    

}
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

