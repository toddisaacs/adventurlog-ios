//
//  Adventure.swift
//  Adventurlog
//
//  Created by Todd Isaacs on 1/22/18.
//  Copyright © 2018 Todd Isaacs. All rights reserved.
//

import Foundation.NSURL

// Query service creates Track objects
class Adventure {
    
    let name: String
    let authorId: String
    let description: String
    let endLocation: [Float]
    let startLocation: [Float]
    
    init(name: String, authorId: String, description: String, startLocation:[Float], endLocation:[Float]) {
        self.name = name
        self.authorId = authorId
        self.description = description
        self.endLocation = endLocation
        self.startLocation = startLocation
    }
    
}


//{
//  "_id": "5a5cb19e041496b715a17ea6",
//  "author": "5a58aafc887c65455e96da15",
//  "name": "First Passage",
//  "description": "First ocean passage",
//  "__v": 0,
//  "endLocation": {
//    "coordinates": [
//    -81.958351,
//    26.459096
//    ],
//    "type": "Point"
//  },
//  "startLocation": {
//    "coordinates": [
//    -82.292618,
//    26.698751
//    ],
//    "type": "Point"
//  },
//  "created": "2018-01-15T13:50:22.937Z",
//  "adventureType": "Sailing"
//}
