//
//  LoginVC.swift
//  TendableApp
//
//  Created by Menti on 15/07/24.
//

import UIKit

class LoginVC: UIViewController {

    //MARK: - Controls
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    //MARK: - Variables and Constants
    let viewModel = LoginViewModel()
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtEmail.text = "mohsin@gmail.com"
        self.txtPassword.text = "12345678"
    }
    
    //MARK: - Button Actions
    @IBAction func btnLoginTapped(_ sender: UIButton){
        viewModel.validLogin(email: txtEmail.text ?? "", password: txtPassword.text ?? "") { success, message, error in
            viewBorderValidation(error: error)
            if !success{
                let alert = UIAlertController(title: Constants.appName, message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: Messages.retry, style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                viewModel.loginNetworkCall(email: txtEmail.text ?? "", password: txtPassword.text ?? "") { success, message in
                    if success{
                        DispatchQueue.main.async {
                            if let user = Constants.shared.getUserDetails(){
                                if user.email == self.txtEmail.text ?? ""{
                                    Constants.shared.currentUser = user
                                }else{
                                    let newUser = UserModel(email: self.txtEmail.text ?? "", isInDraft: false)
                                    Constants.shared.currentUser = newUser
                                    Constants.shared.setUserDetails(user: newUser)
                                }
                            }else{
                                let newUser = UserModel(email: self.txtEmail.text ?? "", isInDraft: false)
                                Constants.shared.currentUser = newUser
                                Constants.shared.setUserDetails(user: newUser)
                            }
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                            let navigationController = UINavigationController(rootViewController: vc)
                            let appdelegate = UIApplication.shared.delegate as! AppDelegate
                            appdelegate.window!.rootViewController = navigationController
                        }
                    }else{
                        let alert = UIAlertController(title: Constants.appName, message: message, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: Messages.retry, style: UIAlertAction.Style.default, handler: nil))
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnRegisterTapped(_ sender: UIButton){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Custom Functions
    func viewBorderValidation(error: ValidationError){
        viewEmail.layer.borderColor = UIColor.clear.cgColor
        viewPassword.layer.borderColor = UIColor.clear.cgColor
        switch error{
        case .emailAndPassword:
            viewEmail.layer.borderColor = UIColor.red.cgColor
            viewEmail.layer.borderWidth = 1
            viewPassword.layer.borderColor = UIColor.red.cgColor
            viewPassword.layer.borderWidth = 1
        case .email:
            viewEmail.layer.borderColor = UIColor.red.cgColor
            viewEmail.layer.borderWidth = 1
        case .password:
            viewPassword.layer.borderColor = UIColor.red.cgColor
            viewPassword.layer.borderWidth = 1
        case .noError:
            break
        }
    }
}
