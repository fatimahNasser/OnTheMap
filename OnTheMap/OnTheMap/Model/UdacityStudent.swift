//
//  UdacityStudent.swift
//  OnTheMap
//
//  Created by ToOoMa on 2019-01-22.
//  Copyright © 2019 Fatimah. All rights reserved.
//

import Foundation


struct UdacityStudent {
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    
    var fullName: String {
        return "\(String(describing: firstName)) \(String(describing: lastName))"
    }
}
