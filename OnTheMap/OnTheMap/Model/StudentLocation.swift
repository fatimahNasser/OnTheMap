//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by ToOoMa on 2019-01-22.
//  Copyright © 2019 Fatimah. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
    
//    var fullName: String {
//        return "\(String(describing: firstName ??)) \(String(describing: lastName ??))"
//    }
}


extension StudentLocation {
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }

    
    
}
