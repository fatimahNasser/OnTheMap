//
//  APIFunc.swift
//  OnTheMap
//
//  Created by ToOoMa on 2019-01-22.
//  Copyright © 2019 Fatimah. All rights reserved.
//

import Foundation
import UIKit

class APIFunc {
    
    private static var student = UdacityStudent()
    private static var sessionId: String?
    static let sharedInstance = APIFunc()
    
    
    static func login(username: String, password: String, completion: @escaping (String?)->Void) {
        guard let url = URL(string: Constants.session) else {
            completion("url not available")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                if statusCode >= 200 && statusCode < 300 {
                    
                    let newData = data?.subdata(in: 5..<data!.count)
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dict = json as? [String:Any],
                        let sessionDict = dict["session"] as? [String: Any],
                        let accountDict = dict["account"] as? [String: Any]  {
                        
                        self.student.uniqueKey = accountDict["key"] as? String
                        self.sessionId = sessionDict["id"] as? String
                        
                        self.getUserInfo(completion: { err in
                            
                        })
                    } else {
                        errString = "Couldn't Find User Data"
                    }
                } else {
                    errString = "Incorrect Login Data"
                }
            } else {
                errString = "Check Your Internet Connection"
            }
            DispatchQueue.main.async {
                completion(errString)
            }
            
        }
        task.resume()
    }
    
    static func getUserInfo(completion: @escaping (Error?)->Void) {
        return
    }
    
    
    static func getStudentLocations(limit: Int = 100, skip: Int = 0, completion: @escaping (Locations?)->Void) {
        guard let url = URL(string: "\(Constants.SLocation)?\(Constants.parseKeys.limit)=\(limit)&\(Constants.parseKeys.skip)=\(skip)&\(Constants.parseKeys.order)=-\("updatedAt")") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.HTTPMethod.get.rawValue
        request.addValue(Constants.parseValues.ApplicationID, forHTTPHeaderField: Constants.parseKeys.ApplicationID)
        request.addValue(Constants.parseValues.APIKey, forHTTPHeaderField: Constants.parseKeys.APIKey)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            var studentLocationsData: [StudentLocation] = []
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200 && statusCode < 300 {
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []),
                        let dict = json as? [String:Any],
                        let results = dict["results"] as? [Any] {
                        
                        for location in results {
                            let data = try! JSONSerialization.data(withJSONObject: location)
                            let studentLocationData = try! JSONDecoder().decode(StudentLocation.self, from: data)
                            
                            studentLocationsData.append(studentLocationData)
                        }
                        
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(Locations(studentLocationsData: studentLocationsData))
            }
        }
        task.resume()
    }
    
    
    
//    static func postLocation(firstName: String, lastName: String, location: String, media: String, latitude: Double, longtitude: Double, completion: @escaping (String?)->Void) {
//
//        guard let url = URL(string: (Constants.SLocation)) else {
//            completion(nil)
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = Constants.HTTPMethod.post.rawValue
//        request.addValue(Constants.parseValues.ApplicationID, forHTTPHeaderField: Constants.parseKeys.ApplicationID)
//        request.addValue(Constants.parseValues.APIKey, forHTTPHeaderField: Constants.parseKeys.APIKey)
//        request.httpBody = "{\"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(media)\",\"latitude\": \(latitude), \"longitude\": \(longtitude)}".data(using: .utf8)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                if statusCode >= 200 && statusCode < 300 {
//                    if error != nil {
//                        print(error!.localizedDescription)
//                        return
//                    }
//
//                    DispatchQueue.main.async {
//                        completion(error!.localizedDescription)
//                    }
//                }
//            }
//
//        }
//
//        task.resume()
//    }
    
    static func postLocation(firstName: String, lastName: String, location: String, media: String, latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Constants.parseValues.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.parseValues.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            
        request.httpBody = "{\"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(media)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
                let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            var err: String?
            if error != nil {
                err = "Data was not successfully posted"
                return
            }
            else{
                
            }
            print (NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            DispatchQueue.main.async {
                completion(err)
            }
        }
        
        task.resume()
        
        
        
        
    }
    
    
    
    func logout(_ completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> Void {
        let url = URL(string: Constants.session)
        
        var request = URLRequest(url: url!)
        request.httpMethod = Constants.HTTPMethod.delete.rawValue
        request.addValue(Constants.parseValues.ApplicationID, forHTTPHeaderField: Constants.parseKeys.ApplicationID)
        request.addValue(Constants.parseValues.APIKey, forHTTPHeaderField: Constants.parseKeys.APIKey)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200 && statusCode < 300 {
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completionHandler(true, nil)
                    }
                }
            }
            
        }
        
        task.resume()
    }
    
}
