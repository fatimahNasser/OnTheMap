//
//  Constants.swift
//  OnTheMap
//
//  Created by ToOoMa on 2019-01-08.
//  Copyright © 2019 Fatimah. All rights reserved.
//

import Foundation

struct Constants {
    
    enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
        //   case put = "PUT"
        case delete = "DELETE"
    }
    
    private static let main = "https://parse.udacity.com"
    static let session = "https://onthemap-api.udacity.com/v1/session"
    static let user = "https://onthemap-api.udacity.com/v1/users/"
    static let SLocation = main + "/parse/classes/StudentLocation"
    
    struct parseKeys {
        static let APIKey = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
        static let limit = "limit"
        static let skip = "skip"
        static let order = "order"
    }
    
    struct parseValues {
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
}

