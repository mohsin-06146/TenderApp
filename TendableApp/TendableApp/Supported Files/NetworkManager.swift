//
//  NetworkManager.swift
//  TendableApp
//
//  Created by Menti on 15/07/24.
//

import Foundation

struct NetworkPackets{
    var method:String!
    var bodyParams:[String:Any]?
    var url:String!
}

struct NetworkPacketsInspection{
    var method:String!
    var inspection:Inspection
    var url:String!
}

enum LoginNetworkError: Error{
    case internetNotThere
    case invalidUser
    case successUser
    case invalidResponse
    case jsonError
    case somethingWentWrong
}

enum NetworkError: Error{
    case internetNotThere
    case invalidResponse
    case jsonError
    case somethingWentWrong
    case success
}

class NetworkManager{
    let timeoutIntervalForRequest = 30000.0
    let timeoutIntervalForResource = 60000.0
    
    func serverCallForLogin(packet: NetworkPackets, completion: @escaping (LoginNetworkError, String) -> Void){
        
        guard Reachability.isConnectedToNetwork() else{
            completion(.internetNotThere, Messages.noInternet)
            return
        }
        
        guard let url = URL(string: packet.url) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = packet.method
        
        urlRequest.addValue("application/json", forHTTPHeaderField:"Content-Type");
        urlRequest.addValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language");
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeoutIntervalForRequest
        sessionConfig.timeoutIntervalForResource = timeoutIntervalForResource
        let session = URLSession(configuration: sessionConfig)
        if urlRequest.httpMethod == "POST"{
            guard let httpBody = try? JSONSerialization.data(withJSONObject: packet.bodyParams ?? [:], options: []) else {
                return
            }
            urlRequest.httpBody = httpBody
        }
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            
            if data?.count == 0{
                completion(.successUser, Messages.userSuccessLogin)
            }else{
                guard let responseData = data else {
                    print("Error: did not receive data")
                    completion(.invalidResponse, Messages.invalidResponse)
                    return
                }
                do {
                    guard let result = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                        completion(.jsonError, Messages.jsonError)
                        return
                    }
                    guard let errorMessage = result["error"] as? String else{
                        completion(.jsonError, Messages.jsonError)
                        return
                    }
                    completion(.invalidUser, errorMessage)
                } catch{
                    completion(.somethingWentWrong, Messages.somethingWentWrong)
                }
            }
        })
        task.resume()
    }
    
    func serverCallForInspectionSubmit(packet: NetworkPacketsInspection, completion: @escaping (LoginNetworkError, String) -> Void){
        
        guard Reachability.isConnectedToNetwork() else{
            completion(.internetNotThere, Messages.noInternet)
            return
        }
        
        guard let url = URL(string: packet.url) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = packet.method
        
        urlRequest.addValue("application/json", forHTTPHeaderField:"Content-Type");
        urlRequest.addValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language");
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeoutIntervalForRequest
        sessionConfig.timeoutIntervalForResource = timeoutIntervalForResource
        let session = URLSession(configuration: sessionConfig)
        if urlRequest.httpMethod == "POST"{
            do{
                let jsonEncoder = JSONEncoder()
                let encodedResponse = try jsonEncoder.encode(packet.inspection)
                urlRequest.httpBody = encodedResponse
                
                let task = session.dataTask(with: urlRequest, completionHandler: {
                    (data, response, error) in
                    
                    if error == nil{
                        completion(.successUser, "")
                    }else{
                        completion(.somethingWentWrong, Messages.somethingWentWrong)
                    }
                })
                task.resume()
                
            } catch{
                completion(.somethingWentWrong, Messages.somethingWentWrong)
            }
        }
        
    }
    
    func serverCallForInspectionGet(packet: NetworkPackets, completion: @escaping (NetworkError, String, Inspection?) -> Void){
        
        guard Reachability.isConnectedToNetwork() else{
            completion(.internetNotThere, Messages.noInternet, nil)
            return
        }
        
        guard let url = URL(string: packet.url) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = packet.method
        
        urlRequest.addValue("application/json", forHTTPHeaderField:"Content-Type");
        urlRequest.addValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language");
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeoutIntervalForRequest
        sessionConfig.timeoutIntervalForResource = timeoutIntervalForResource
        let session = URLSession(configuration: sessionConfig)
        if urlRequest.httpMethod == "POST"{
            guard let httpBody = try? JSONSerialization.data(withJSONObject: packet.bodyParams ?? [:], options: []) else {
                return
            }
            urlRequest.httpBody = httpBody
        }
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            
            if data?.count == 0{
                completion(.somethingWentWrong, Messages.somethingWentWrong, nil)
            }else{
                guard let responseData = data else {
                    completion(.invalidResponse, Messages.invalidResponse, nil)
                    return
                }
                do {
                    guard let result = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        completion(.invalidResponse, Messages.invalidResponse, nil)
                        return
                    }
                    Constants.shared.response = result
                    
                    let jsonDecoder = JSONDecoder()
                    let decodedResponse = try jsonDecoder.decode(Inspection.self, from: data ?? Data())
                    completion(.success, "", decodedResponse)
                    
                } catch{
                    completion(.somethingWentWrong, Messages.somethingWentWrong, nil)
                }
            }
        })
        task.resume()
    }
}
