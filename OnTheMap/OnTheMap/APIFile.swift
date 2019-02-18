////
////  APIFile.swift
////  OnTheMap
////
////  Created by ToOoMa on 2019-01-05.
////  Copyright © 2019 Fatimah. All rights reserved.
////
//
//import Foundation
//
//enum studentInfo: String {
//        case objectID
//        case uniqueKey
//        case firstName
//        case lastName
//        case mapString
//        case latitude
//        case longitude
//        case mediaUrl
//        case createdAt
//        case updatedAt
//}
//
////struct StudentLocation: Codable {
////    var createdAt: String?
////    var firstName: String?
////    var lastName: String?
////    var latitude: Double?
////    var longitude: Double?
////    var mapString: String?
////    var mediaURL: String?
////    var objectId: String?
////    var uniqueKey: String?
////    var updatedAt: String?
////}
//
////struct UdacityStudent {
////    var uniqueKey: String?
////    var firstName: String?
////    var lastName: String?
////
////    var fullName: String {
////        return "\(String(describing: firstName)) \(String(describing: lastName))"
////    }
////}
//
////struct Locations {
////    var studentLocationsData: [StudentLocation] = []
////}
//
//
//
//class APIFile {
//    
//    private static var udacityStudent = UdacityStudent()
//    private static var sessionId: String?
//    
//    static func postSession(username: String, password: String, completion: @escaping (String?)->Void) {
//        guard let url = URL(string: Constants.session) else {
//            completion("url not available")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = Constants.HTTPMethod.post.rawValue
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            var errString: String?
//            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                
//                if statusCode >= 200 && statusCode < 300 {
//                    
//                    let newData = data?.subdata(in: 5..<data!.count)
//                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
//                        let dict = json as? [String:Any],
//                        let sessionDict = dict["session"] as? [String: Any],
//                        let accountDict = dict["account"] as? [String: Any]  {
//                        
//                        self.udacityStudent.uniqueKey = accountDict["key"] as? String
//                        self.sessionId = sessionDict["id"] as? String
//                        
//                        self.getUserInfo(completion: { err in
//                            
//                        })
//                    } else {
//                        errString = "Couldn't Find Location"
//                    }
//                } else {
//                    errString = "Incorrect Login Data"
//                }
//            } else {
//                errString = "Check Your Internet Connection"
//            }
//            DispatchQueue.main.async {
//                completion(errString)
//            }
//            
//        }
//        task.resume()
//    }
//    
//    static func getUserInfo(completion: @escaping (Error?)->Void) {
//    }
//    
//    class Parser {
//        
//        static func getStudentLocations(limit: Int = 100, skip: Int = 0, orderBy: studentInfo = .updatedAt, completion: @escaping (Locations?)->Void) {
//            guard let url = URL(string: "\(Constants.SLocation)?\(Constants.parseKeys.limit)=\(limit)&\(Constants.parseKeys.skip)=\(skip)&\(Constants.parseKeys.order)=-\(orderBy.rawValue)") else {
//                completion(nil)
//                return
//            }
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = Constants.HTTPMethod.get.rawValue
//            request.addValue(Constants.parseValues.ApplicationID, forHTTPHeaderField: Constants.parseKeys.ApplicationID)
//            request.addValue(Constants.parseValues.APIKey, forHTTPHeaderField: Constants.parseKeys.APIKey)
//            let session = URLSession.shared
//            let task = session.dataTask(with: request) { data, response, error in
//                var studentLocationsData: [StudentLocation] = []
//                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                    if statusCode >= 200 && statusCode < 300 {
//                        if let json = try? JSONSerialization.jsonObject(with: data!, options: []),
//                            let dict = json as? [String:Any],
//                            let results = dict["results"] as? [Any] {
//                            
//                            for location in results {
//                                let data = try! JSONSerialization.data(withJSONObject: location)
//                                let studentLocationData = try! JSONDecoder().decode(StudentLocation.self, from: data)
//                                studentLocationsData.append(studentLocationData)
//                            }
//                            
//                        }
//                    }
//                }
//                
//                DispatchQueue.main.async {
//                    completion(Locations(studentLocationsData: studentLocationsData))
//                }
//                
//            }
//            task.resume()
//        }
//        
//        static func postLocation(firstName: String, lastName: String, location: String, media: String, latitude: String, longtitude: String) {
//            var url = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
//            let headers = [
//                "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
//                "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY",
//                "Content-Type": "application/json"
//            ]
//            
//           postSession(url, body: location.json, headers: headers) { (data, response, error) in
//               if error != nil {
//                  completionHandler(self.process(responseAndError: response, error: error))
//                   return
//                }
//                completionHandler(nil)
//          }
//       }
//    }
//}
