//
//  SingleQuoteViewController.swift
//  Motivation
//
//  Created by Atahan Sahlan on 17/02/2021.
//

import UIKit

class SingleQuoteViewController: UIViewController {
//
//
//    @IBAction func LikeBtn(_ sender: Any) {
//
//        if Quotes!.count > currentQuote{
//        if !Quotes![currentQuote].isLiked{
//        database().addUserFavoriteQuote(text: Quotes![currentQuote].text!, author: Quotes![currentQuote].author!, number: Quotes![currentQuote].number!)
//        Quotes![currentQuote].isLiked = true
//        }else{
//            database().deleteUserFavoriteQuote(number: Quotes![currentQuote].number!)
//            Quotes![currentQuote].isLiked = false
//        }
//        self.CheckifLiked()
//        }
//
//
//    }
//    @IBAction func ShareBtn(_ sender: Any) {
//        HideOrBringBackItems(isHidden: true)
//
//        let data = self.view.takeScreenshot()
//               let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
//               UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
//        HideOrBringBackItems(isHidden: false)
//
//    }
//    func HideOrBringBackItems(isHidden: Bool){
//        FavoritesBtn.isHidden = isHidden
//        ForYouBtn.isHidden = isHidden
//        LikeBtnOutlet.isHidden = isHidden
//        ProfileBtn.isHidden = isHidden
//        ShareBtnOutlet.isHidden = isHidden
//        MoreBtnOutlet.isHidden = isHidden
//    }
//    @IBAction func MoreBtn(_ sender: Any) {
//        let alert = UIAlertController(title: "Is something wrong?", message: "Please Select an Option", preferredStyle: .actionSheet)
//
//            alert.addAction(UIAlertAction(title: "Report quote", style: .default , handler:{ (UIAlertAction)in
//                self.nextQuote()
//            }))
//
//            alert.addAction(UIAlertAction(title: "Block the writer", style: .destructive , handler:{ (UIAlertAction)in
//                self.nextQuote()
//            }))
//
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
//            }))
//
//
//            //uncomment for iPad Support
//            alert.popoverPresentationController?.sourceView = self.view
//
//            self.present(alert, animated: true, completion: {
//            })
//    }
//
//    @IBAction func FavoritesClicked(_ sender: Any) {
//        if isForYou{
//        let AvenirLight = NSAttributedString(string: "For You", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir Light", size: 21)!])
//        ForYouBtn.setAttributedTitle(AvenirLight, for: .normal)
//        let AvenirMedium = NSAttributedString(string: "Favorites", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir Medium", size: 21)!])
//        FavoritesBtn.setAttributedTitle(AvenirMedium, for: .normal)
//
//        getFavoriteQuotes()
//        isForYou.toggle()
//        }
//
////        ForYouBtn.titleLabel!.font =  UIFont(name: "Avenir Light", size: 21)
////        FavoritesBtn.titleLabel!.font =  UIFont(name: "Avenir Medium", size: 21)
////        ForYouBtn.titleLabel!.textColor = .white
////        FavoritesBtn.titleLabel!.textColor = .gray
//
//    }
//    @IBOutlet weak var panView: UIView!
//
//    var viewCenter: CGPoint!
//    var AuthorTextCenter: CGPoint!
//
//    var isForYou = true
//    var Quotes: [Quote]?
//    var currentQuote = 0
//    let userDefaults = UserDefaults(suiteName: "group.Sahlan.Motivation")
//
//    var favoriteQuotes: [String]?
//    var favoriteAuthors: [String]?
//
//    var UserQuotesText: [String]?
//    var UserQuotesAuthor: [String]?
//    var numberofUserQuotes = 0
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragView)))
//
//        viewCenter = QuoteText.center
//        AuthorTextCenter = AuthorText.center
//
//        QuoteText.numberOfLines = 10
//        QuoteText.font = QuoteText.font.withSize(70)
//        QuoteText.adjustsFontSizeToFitWidth = true
//        QuoteText.minimumScaleFactor = 0.3
//
//        FavoritesBtn.titleLabel!.font =  UIFont(name: "Avenir Light", size: 21)
//        ForYouBtn.titleLabel!.font =  UIFont(name: "Avenir Medium", size: 21)
//        ForYouBtn.titleLabel!.textColor = .gray
//        FavoritesBtn.titleLabel!.textColor = .white
//       // view = BackgroundGradientView
//
//        // Do any additional setup after loading the view.
//    }
//    @objc func dragView(gesture: UIPanGestureRecognizer) {
//            let translation = gesture.translation(in: self.view)
//
//            switch gesture.state {
//
//                //viewCenter = target.center
//
//            case .changed:
//                QuoteText.center = CGPoint(x: viewCenter!.x, y: viewCenter!.y + translation.y)
//                AuthorText.center = CGPoint(x: AuthorText.center.x, y: AuthorTextCenter.y + translation.y)
//
//            case .ended:
//
//                if translation.y > 50{
//                    previousQuote()
//                }
//                if translation.y < -50{
//                    nextQuote()
//
//                }
//                //QuoteText.center = viewCenter
//
//            default: break
//            }
//        }
//    func nextQuote(){
//        UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
//
//            var quoteframe = self.QuoteText.frame
//            quoteframe.origin.y -= 400
//            self.QuoteText.frame = quoteframe
//
//            var authorframe = self.AuthorText.frame
//            authorframe.origin.y -= 400
//            self.AuthorText.frame = authorframe
//
//        }, completion: { finished in
//            if self.isForYou{
//
//            if self.currentQuote + 10 > self.Quotes?.count ?? 0{
//                self.getQuotes()
//                self.QuoteText.center = self.viewCenter
//                self.AuthorText.center = self.AuthorTextCenter
//            }
//            else{
//                self.currentQuote += 1
//                self.QuoteText.text = self.Quotes![self.currentQuote].text
//                self.AuthorText.text = self.Quotes![self.currentQuote].author
//                self.QuoteText.center = self.viewCenter
//                self.AuthorText.center = self.AuthorTextCenter
//                self.CheckifLiked()
//            }
//            }else{
//
//
//                if self.currentQuote == self.Quotes!.count-1{
//                    self.QuoteText.center = self.viewCenter
//                    self.AuthorText.center = self.AuthorTextCenter
//                }else{
//                self.currentQuote += 1
//                self.QuoteText.text = self.Quotes![self.currentQuote].text
//                self.AuthorText.text = self.Quotes![self.currentQuote].author
//                self.QuoteText.center = self.viewCenter
//                self.AuthorText.center = self.AuthorTextCenter
//                    self.CheckifLiked()
//                }
//            }
//
//        })
//    }
//    func previousQuote(){
//        UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
//
//            var quoteframe = self.QuoteText.frame
//            quoteframe.origin.y += 400
//            self.QuoteText.frame = quoteframe
//
//            var authorframe = self.AuthorText.frame
//            authorframe.origin.y += 400
//            self.AuthorText.frame = authorframe
//
//        }, completion: { finished in
//            if self.currentQuote == 0{
//                self.QuoteText.center = self.viewCenter
//                self.AuthorText.center = self.AuthorTextCenter
//            }else{
//            self.currentQuote -= 1
//            self.QuoteText.text = self.Quotes![self.currentQuote].text
//            self.AuthorText.text = self.Quotes![self.currentQuote].author
//            self.QuoteText.center = self.viewCenter
//            self.AuthorText.center = self.AuthorTextCenter
//                self.CheckifLiked()
//            }
//
//        })
//
//    }
//
//    func likeLikedQuotes(){
//        for Quote in Quotes!{
//            Quote.isLiked = true
//        }
//
//    }
//
//    func CheckifLiked(){
//        if self.Quotes![self.currentQuote].isLiked{
//            self.LikeBtnOutlet.setBackgroundImage(UIImage(systemName:"heart.fill"), for: .normal)
//        }else{
//            self.LikeBtnOutlet.setBackgroundImage(UIImage(systemName:"heart"), for: .normal)
//        }
//    }
//
//    override func viewDidLayoutSubviews() {
//        view.gradientBackground(from: Colors().color1, to: Colors().color2, direction: .topleftToBottomright)
//    }
//
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//extension UIView {
//    enum GradientDirection {
//        case leftToRight
//        case rightToLeft
//        case topToBottom
//        case bottomToTop
//        case topleftToBottomright
//    }
//    func gradientBackground(from color1: UIColor, to color2: UIColor, direction: GradientDirection) {
//        let gradient = CAGradientLayer()
//        gradient.frame = self.bounds
//        gradient.colors = [color1.cgColor, color2.cgColor]
//
//        switch direction {
//        case .leftToRight:
//            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
//            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
//        case .rightToLeft:
//            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
//            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
//        case .bottomToTop:
//            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
//            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
//        case .topleftToBottomright:
//            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
//            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
//        default:
//            break
//        }
//
//        self.layer.insertSublayer(gradient, at: 0)
//    }
}
