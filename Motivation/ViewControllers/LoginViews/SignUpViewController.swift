//
//  SignUpViewController.swift
//  Motivation
//
//  Created by Atahan Sahlan on 20/12/2020.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import CryptoKit
import AuthenticationServices



class SignUpViewController: UIViewController, LoginButtonDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @IBOutlet weak var AppleSignInBtn: ASAuthorizationAppleIDButton!
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view as! ASPresentationAnchor
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
           print(error.localizedDescription)
           return
         }
        if AccessToken.current != nil{
            print(result)
             let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            let authError = error as NSError
            DispatchQueue.main.async {
                database().createUser(email:Auth.auth().currentUser?.email ?? "", username: Auth.auth().currentUser?.displayName ?? "", uid: String(Auth.auth().currentUser!.uid))
            }
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "main") as! UITabBarController
                secondViewController.modalPresentationStyle = .fullScreen
                self.present(secondViewController, animated: true) {}
          // User is signed in
          // ...
        }
    }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    fileprivate var currentNonce: String?

    @IBOutlet weak var SignUpBtnOutlet: UIButton!
    @IBOutlet weak var EmailField: UITextField!

    @IBOutlet weak var PassField: UITextField!
    @IBOutlet weak var PassAgainField: UITextField!
    @IBOutlet weak var UsernameField: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    @objc func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
          }
          // Initialize a Firebase credential.
          let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                    idToken: idTokenString,
                                                    rawNonce: nonce)
          // Sign in with Firebase.
          Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
              // Error. If error.code == .MissingOrInvalidNonce, make sure
              // you're sending the SHA256-hashed nonce as a hex string with
              // your request to Apple.
                print(error?.localizedDescription)
                print(authResult)
                DispatchQueue.main.async {
                    database().createUser(email:Auth.auth().currentUser!.email ?? "", username: Auth.auth().currentUser!.displayName ?? "", uid: String(Auth.auth().currentUser!.uid))
                
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
                  
              return
            }
            // User is signed in to Firebase with Apple.
            // ...
          }
        }
      

      func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
      }

    }
    

    @IBAction func SignUpBtn(_ sender: Any) {
        if (EmailField.text != "" && (PassField.text == PassAgainField.text) && UsernameField.text != ""){
        Auth.auth().createUser(withEmail: EmailField.text!, password: PassField.text!) { authResult, error in
            if error == nil{
                DispatchQueue.main.async {
                database().createUser(email: self.EmailField.text!, username: self.UsernameField.text!, uid: String(Auth.auth().currentUser!.uid))
                }
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
                    
                
               
            }else{
                let alertController = UIAlertController(title: error?.localizedDescription, message: "", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default))
                self.present(alertController, animated: true,completion: nil)
            }
          // ...
        }

        }else{
            let alertController = UIAlertController(title: "Please make sure you fill all the fields", message: "Try again", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default))
            self.present(alertController, animated: true,completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        addFacebookLoginBtn()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        makeFieldsLineOnly()
        addShadows()
        AppleSignInBtn.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)

        if let token = AccessToken.current,
                !token.isExpired {
                //facebook User is logged in, do work such as go to next view controller.
            }
       // GIDSignIn.sharedInstance().signIn()
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
          // ...
            if auth.currentUser != nil{
                DispatchQueue.main.async {
                    database().createUser(email:Auth.auth().currentUser?.email ?? "", username: Auth.auth().currentUser?.displayName ?? "", uid: String(Auth.auth().currentUser!.uid))
                }
                database().isInitialLaunch(uid: Auth.auth().currentUser!.uid){bool in
                    print("bura")
                    if bool{
                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "CategoryPicker") as! CategoryViewController
                        secondViewController.modalPresentationStyle = .fullScreen
                        self.present(secondViewController, animated: true)
                    }else{
                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "main") as! UITabBarController
                        secondViewController.modalPresentationStyle = .fullScreen
                        self.present(secondViewController, animated: true) {}
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    func addShadows(){
        SignUpBtnOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        SignUpBtnOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        SignUpBtnOutlet.layer.shadowOpacity = 1.0
        SignUpBtnOutlet.layer.shadowRadius = 5.0
        SignUpBtnOutlet.layer.masksToBounds = false
    }
    func makeFieldsLineOnly(){

        let EmailLine = CALayer()
        let UsernameLine = CALayer()
        let PassLine = CALayer()
        let PassagainLine = CALayer()

        EmailLine.backgroundColor = UIColor.white.cgColor
        UsernameLine.backgroundColor = UIColor.white.cgColor
        PassLine.backgroundColor = UIColor.white.cgColor
        PassagainLine.backgroundColor = UIColor.white.cgColor
        
        EmailField.attributedPlaceholder = NSAttributedString(string: "Email",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray6])
        UsernameField.attributedPlaceholder = NSAttributedString(string: "Username",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray6])
        PassField.attributedPlaceholder = NSAttributedString(string: "Password",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray6])
        PassAgainField.attributedPlaceholder = NSAttributedString(string: "Password Again",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray6])

        EmailField.borderStyle = .none
        UsernameField.borderStyle = .none
        PassField.borderStyle = .none
        PassAgainField.borderStyle = .none
        
        EmailLine.frame = CGRect(x: 0, y: EmailField.frame.height - 2, width: EmailField.frame.width, height: 2)
        EmailField.layer.addSublayer(EmailLine)
        
        UsernameLine.frame = CGRect(x: 0, y: UsernameField.frame.height - 2, width: UsernameField.frame.width, height: 2)
        UsernameField.layer.addSublayer(UsernameLine)
        
        PassLine.frame = CGRect(x: 0, y: PassField.frame.height - 2, width: PassField.frame.width, height: 2)
        PassField.layer.addSublayer(PassLine)
        
        PassagainLine.frame = CGRect(x: 0, y: PassAgainField.frame.height - 2, width: PassAgainField.frame.width, height: 2)
        PassAgainField.layer.addSublayer(PassagainLine)
    }
    func addFacebookLoginBtn(){
     let loginButton = FBLoginButton()
            loginButton.center = view.center
        loginButton.permissions = ["public_profile", "email"]
        loginButton.delegate = self
            view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 290).isActive = true
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
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
