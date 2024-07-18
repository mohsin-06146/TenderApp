//
//  LoginViewModel.swift
//  TendableApp
//
//  Created by Menti on 15/07/24.
//

import Foundation

enum ValidationError{
    case emailAndPassword
    case email
    case password
    case noError
}

class LoginViewModel{
    func validLogin(email: String, password: String, completion: ((Bool, String, ValidationError) -> Void)){
        if email == "" && password == ""{
            completion(false, Messages.bothfieldsareRequired, .emailAndPassword)
        }else if !self.isValidEmail(email: email){
            completion(false, Messages.validEmail, .email)
        }else if !self.isValidPassword(password: password){
            completion(false, Messages.validPassWord, .password)
        }else{
            completion(true, "", .noError)
        }
    }
    
    func loginNetworkCall(email: String, password: String, completion: @escaping ((Bool, String) -> Void)){
        let networkManager = NetworkManager()
        let param: [String: Any] = [
            "email": email,
            "password": password
        ]
        let url = Constants.endPoint + "login"
        networkManager.serverCallForLogin(packet: NetworkPackets(method: "post", bodyParams: param, url: url)) { error, message in
            if error == .successUser{
                completion(true, message)
            }else{
                completion(false, message)
            }
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        return password.count >= 8 ? true : false
    }
}



