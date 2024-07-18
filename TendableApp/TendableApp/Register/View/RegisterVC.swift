//
//  RegisterVC.swift
//  TendableApp
//
//  Created by Menti on 15/07/24.
//

import UIKit

class RegisterVC: UIViewController {
   
    //MARK: - Controls
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    //MARK: - Variables and Constants
    let viewModel = RegisterViewModel()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Button Actions
    @IBAction func btnRegisterTapped(_ sender: UIButton){
        viewModel.validRegister(email: txtEmail.text ?? "", password: txtPassword.text ?? "") { success, message, error in
            viewBorderValidation(error: error)
            if !success{
                let alert = UIAlertController(title: Constants.appName, message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: Messages.retry, style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                viewModel.registerNetworkCall(email: txtEmail.text ?? "", password: txtPassword.text ?? "") { success, message in
                    if success{
                        let alert = UIAlertController(title: Constants.appName, message: message, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: Messages.login, style: .default, handler: { action in
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }))
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
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
