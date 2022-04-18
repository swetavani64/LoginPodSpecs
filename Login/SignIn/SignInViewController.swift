//
//
//  SignInViewController.swift
//  ECommerceBrainvire
//
//  Created by Sweta Vani on 06/04/22.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import Alamofire
import Firebase
import GoogleSignIn
import MobikulFBSignI
import FBSDKLoginKit

class SignInViewController: ParentController {
    
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var viewAppleSignIn:UIView!
    
    //MARK: - Variables
    var userEmail: String = ""
    let button = UIButton(type: .custom)
    var viewModel = SignInViewModel()
    var parentController = ""
    var email: String?
    var signInHandler: (() -> ())?
    let fbLoginManager : LoginManager = LoginManager()
    
    //MARK: - Viewcontroller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        passwordTextField.delegate = self
        DispatchQueue.main.async {
            self.emailTextField.label.text = "Email".localized + "*"
            self.passwordTextField.label.text = "Password".localized
            self.emailTextField.placeholder = "Email".localized + "*"
            self.passwordTextField.placeholder = "Password".localized
            self.emailTextField.setOutlineColor(AppStaticColors.LightAccentColor, for: .normal)
            self.emailTextField.setFloatingLabelColor(AppStaticColors.accentColor, for: .normal)
            self.emailTextField.setNormalLabelColor(AppStaticColors.LightAccentColor, for: .normal)
            self.emailTextField.label.font = UIFont.mySystemFont(ofSize: 17.0)
            
            self.passwordTextField.setOutlineColor(AppStaticColors.LightAccentColor, for: .normal)
            self.passwordTextField.setFloatingLabelColor(AppStaticColors.accentColor, for: .normal)
            self.passwordTextField.setNormalLabelColor(AppStaticColors.LightAccentColor, for: .normal)
            self.passwordTextField.label.font = UIFont.mySystemFont(ofSize: 17.0)
            
            
            if #available(iOS 12.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    self.emailTextField.textColor = UIColor.white
                    self.passwordTextField.textColor = UIColor.white
                    
                    self.emailTextField.setFloatingLabelColor(AppStaticColors.accentColor, for: .normal)
                    self.emailTextField.setNormalLabelColor(AppStaticColors.accentColor, for: .normal)
                    self.passwordTextField.setFloatingLabelColor(AppStaticColors.accentColor, for: .normal)
                    self.passwordTextField.setNormalLabelColor(AppStaticColors.accentColor, for: .normal)
                } else {
                    self.emailTextField.textColor = AppStaticColors.accentColor
                    self.passwordTextField.textColor = AppStaticColors.accentColor
                }
            } else {
                self.emailTextField.textColor = AppStaticColors.accentColor
                self.passwordTextField.textColor = AppStaticColors.accentColor
            }
        }
        
        //MARK: - code for hide show btn
        button.setTitle("Show", for: .normal)
        button.setTitleColor(UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 28.0/255.0, alpha: 0.6), for: .normal)
        button.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(50), height: CGFloat(30))
        button.addTarget(self, action: #selector(self.revealPassword), for: .touchUpInside)
        
        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
        if let email = email {
            emailTextField.text = email
            passwordTextField.text = ""
        }
        if #available(iOS 12.0, *) {
            emailTextField.textContentType = .username
            passwordTextField.textContentType = .password
        }
        
        if Defaults.language == "ar" {
            emailTextField.semanticContentAttribute = .forceRightToLeft
            passwordTextField.semanticContentAttribute = .forceRightToLeft
            emailTextField.textAlignment = .right
            passwordTextField.textAlignment = .right
        } else {
            emailTextField.semanticContentAttribute = .forceLeftToRight
            passwordTextField.semanticContentAttribute = .forceLeftToRight
            emailTextField.textAlignment = .left
            passwordTextField.textAlignment = .left
        }
        
        if #available(iOS 13.0, *) {
            HSAppleSignIn.shared.loginWithApple(view: viewAppleSignIn, type: .signIn, style: .whiteOutline) { (userInfo) in
                //print(userInfo?.fullName)
                if userInfo?.email ?? "" != "" {
                    var dictGuser = ["token":"\(userInfo?.userid ?? "")","firstName":"\(userInfo?.firstName ?? "")","lastName":"\(userInfo?.lastName ?? "")","email":"\(userInfo?.email ?? "")"]
                    //self.callRequest(dict: dictGuser, apiCall: .createAccount)
                }
            }
        } else {
            viewAppleSignIn.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.addSelectContentEvent(dict: ["screen":"SignInViewController.class"])
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Gmail Click
    @IBAction func googleClick(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK: - Fb Click
    @IBAction func fbClicked(_ sender: Any) {
        self.facebooklogin()
    }
    
    // MARK: - revel password func
    @objc func revealPassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if passwordTextField.isSecureTextEntry {
            //            button.setImage(UIImage(named: "closePassword"), for: .normal)
            
            button.setTitle("Show", for: .normal)
            
            //button.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(30), height: CGFloat(25))
            
        } else {
            
            button.setTitle("Hide", for: .normal)
            
            // button.setImage(UIImage(named: "seePassword"), for: .normal)
        }
    }
    
    // MARK: - forget password
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let AC = UIAlertController(title: "enteremail".localized, message: "", preferredStyle: .alert)
        AC.addTextField { (textField) in
            textField.placeholder = "enteremail".localized
            textField.text = self.emailTextField.text
        }
        let okBtn = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let textField = AC.textFields![0]
            guard let emailId = textField.text, emailId.count>1 else {
                ShowNotificationMessages.sharedInstance.showWarningSnackBar(message: "pleasefillemailid".localized)
                return
            }
            if !emailId.checkValidEmail(data: emailId) {
                ShowNotificationMessages.sharedInstance.showWarningSnackBar(message: "pleaseentervalidemail".localized)
                return
            }
            var dict = [String: Any]()
            dict["username"] = emailId
            //self.callRequest(dict: dict, apiCall: .forgetPassword)
        })
        let noBtn = UIAlertAction(title: "Cancel", style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.present(AC, animated: true, completion: {  })
    }
    
    // MARK: - Textfield Actions
    @IBAction func txtAction_EmailChangeValue(_ sender: Any) {
        if emailTextField.text?.count == 0 || passwordTextField.text!.count < 8  {
            self.changeColorOfButtom(false)
        } else {
            if !emailTextField.text!.checkValidEmail(data: emailTextField.text!) {
                self.changeColorOfButtom(false)
            } else {
                self.changeColorOfButtom(true)
            }
            
        }
    }
    
    @IBAction func txtAction_password(_ sender: Any) {
        
        if emailTextField.text?.count == 0 || passwordTextField.text!.count < 6  {
            self.changeColorOfButtom(false)
        } else {
            if !emailTextField.text!.checkValidEmail(data: emailTextField.text!) {
                self.changeColorOfButtom(false)
            } else {
                self.changeColorOfButtom(true)
            }
            
        }
    }
    
    // MARK: - sign act
    @IBAction func signInAction(_ sender: Any) {
        
        self.changeColorOfButtom(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            guard let emailId = self.emailTextField.text, emailId.count != 0 else {
                ShowNotificationMessages.sharedInstance.showWarningSnackBar(message: "Email is Required")
                self.emailTextField.shake()
                self.changeColorOfButtom(false)
                return
            }
            
            if !emailId.checkValidEmail(data: emailId) {
                ShowNotificationMessages.sharedInstance.showWarningSnackBar(message: "Enter valid Email")
                self.emailTextField.shake()
                self.changeColorOfButtom(false)
                return
            }
            
            guard let password = self.passwordTextField.text, password.count != 0 else {
                ShowNotificationMessages.sharedInstance.showWarningSnackBar(message: "Password is Required")
                self.passwordTextField.shake()
                self.changeColorOfButtom(false)
                return
            }
            
            guard password.count >= 6 else {
                ShowNotificationMessages.sharedInstance.showWarningSnackBar(message: strValidPassword)
                self.passwordTextField.shake()
                self.changeColorOfButtom(false)
                return
            }
            
            var dict = [String: Any]()
            dict["username"] = self.emailTextField.text ?? ""
            dict["password"] = self.passwordTextField.text ?? ""
            dict["token"] = Defaults.deviceToken
            //self.callRequest(dict: dict, apiCall: .login)
        }
    }
    
    func changeColorOfButtom(_ isNormal : Bool) {
        if isNormal == false {
            self.signInButton.backgroundColor = .white
            self.signInButton.borderColor = AppStaticColors.accentColor
            self.signInButton.borderWidth = 1.0
            self.signInButton.setTitleColor(AppStaticColors.accentColor, for: .normal)
        } else {
            self.signInButton.backgroundColor = AppStaticColors.accentColor
            self.signInButton.borderWidth = 0.0
            self.signInButton.setTitleColor(.white, for: .normal)
        }
    }
    
    // MARK: - Api act
    /*
     func callRequest(dict: [String: Any], apiCall: WhichApiCall) {
     viewModel.callingHttppApi(dict: dict, apiCall: apiCall) { [weak self] success in
     NetworkManager.sharedInstance.dismissLoader()
     guard self != nil else { return }
     if success {
     if apiCall == .login {
     ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: "Login Successfully".localized)
     self?.removeGuestUserdefaultData()
     //self?.navigationController?.popToRootViewController(animated: true)
     
     if let signInHandler = self?.signInHandler {
     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
     signInHandler()
     } else {
     //self?.navigationController?.popToRootViewController(animated: true)
     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
     LaunchHome.shared.launchHome()
     }
     } else if apiCall == .createAccount {
     self?.removeGuestUserdefaultData()
     //self?.navigationController?.popToRootViewController(animated: true)
     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
     LaunchHome.shared.launchHome()
     } else {
     
     }
     } else {
     }
     }
     }
     */
    
    // MARK: - close btn act
    @IBAction func closeAct(_ sender: Any) {
        
        //        if delegate != nil {
        //            self.delegate?.loginPop()
        //        }else{
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        //}
        
    }
    
    //    @IBAction func createAnAccountAct(_ sender: Any) {
    //
    //        let customerCreateAccountVC = CreateAnAccountViewController.instantiate(fromAppStoryboard: .customer)
    //                   customerCreateAccountVC.parentController = "signIn"
    //                   customerCreateAccountVC.delegate = delegate
    //                   customerCreateAccountVC.modalPresentationStyle = .fullScreen
    //                   self.navigationController?.pushViewController(customerCreateAccountVC, animated: true)
    //    }
    
    //MARK: - Facebook
    
    func facebooklogin() {
        
        //let fbLoginManager : LoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            
            print("\n\n result: \(String(describing: result))")
            
            print("\n\n Error: \(error)")
            
            if error == nil {
                let fbloginresult : LoginManagerLoginResult = result!
                //get email form graph request based on token
                if fbloginresult.isCancelled {
                    //Show Cancel alert
                } else if fbloginresult.grantedPermissions.contains("email") {
                    
                    self.returnUserData(fbToken: fbloginresult.token!)
                }
            } else {
                print("error")
            }
        }
        
    }
    
    func returnUserData(fbToken : AccessToken) {
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,first_name,last_name"])
        graphRequest.start { connection, result, error in
            if (error) != nil {
                
                print("\n\n Error: \(String(describing: error))")
            } else {
                if let resultDic = result as? NSDictionary{
                    print("\n\n  fetched user: \(String(describing: result))")
                    
                    let fname = resultDic.value(forKey:"first_name")! as? String
                    let lname = resultDic.value(forKey:"last_name")! as? String
                    let userId = resultDic.value(forKey:"id")! as? String
                    
                    let facebookProfileUrl = "http://graph.facebook.com/\(userId)/picture?type=large"
                    
                    if resultDic.value(forKey:"email") != nil {
                        let userEmail = resultDic.value(forKey:"email")! as? String
                        
                        let dictGuser = ["token":"\(userId ?? "")","firstName":"\(fname ?? "")","lastName":"\(lname ?? "")","email":"\(userEmail ?? "")","pictureURL":"\(facebookProfileUrl)"]
                        
                        print(dictGuser)
                        //self.callRequest(dict: dictGuser, apiCall: .createAccount)
                        //AppEvents.logEvent(AppEvents.Name.init(rawValue: "Login with Facebook"))
                    } else {
                        let AC = UIAlertController(title: projectName, message: strFacebook, preferredStyle: .alert)
                        let noBtn = UIAlertAction(title: "DISMISS", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            //let fbLoginManager : LoginManager = LoginManager()
                            self.fbLoginManager.logOut()
                            AccessToken.current = nil
                            Profile.current = nil
                            //                            let deletepermission = GraphRequest.init(graphPath: "me/permissions/", httpMethod: HTTPMethod.delete)
                            //                            deletepermission.start(completionHandler: {(connection,result,error)-> Void in
                            //                            print("the delete permission is (result)")
                            //                            })
                        })
                        let yesBtn = UIAlertAction(title: "TRY AGAIN", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            self.fbLoginManager.logOut()
                            AccessToken.current = nil
                            Profile.current = nil
                        })
                        AC.addAction(noBtn)
                        AC.addAction(yesBtn)
                        self.navigationController?.present(AC, animated: true, completion: {})
                        //                        let dictGuser = ["token":"\(userId)","firstName":"\(fname)","lastName":"\(fname)","email":"","pictureURL":"\(facebookProfileUrl)"]
                        //
                        //                        print(dictGuser)
                        //
                        //                        self.callRequest(dict: dictGuser, apiCall: .createAccount)
                    }
                }
            }
        }
    }
}
//GIDSignInUIDelegate
extension SignInViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            if user != nil {
                let dictGuser = ["token":"\(user.authentication.idToken!)","firstName":"\(user.profile.givenName!)","lastName":"\(user.profile.familyName!)","email":"\(user.profile.email!)","pictureURL":"\(user.profile.imageURL(withDimension: 300)!)"]
                
                print(dictGuser)
                
                //self.callRequest(dict: dictGuser, apiCall: .createAccount)
            }
            
            
        }
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SignInViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        return true
    }
}
