//
//  Constants.swift
//  TendableApp
//
//  Created by Menti on 15/07/24.
//

import Foundation

struct Constants{
    static var shared = Constants()
    
    static let appName = "TendableApp"
    static let endPoint = "http://127.0.0.1:5001/api/"
    var currentUser = UserModel(email: "", isInDraft: false)
    var response: [String: Any] = [:]
    
    func setUserDetails(user: UserModel){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: "user")
        } catch {
            // Fallback
        }
    }
    
    func getUserDetails() -> UserModel?{
        guard let data = UserDefaults.standard.data(forKey: "user") else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(UserModel.self, from: data)
            return user
        } catch {
            // Fallback
        }
        return nil
    }
}
