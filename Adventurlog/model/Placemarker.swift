//
//  Placemarker.swift
//  Adventurlog
//
//  Created by Todd Isaacs on 1/23/18.
//  Copyright © 2018 Todd Isaacs. All rights reserved.
//

import Foundation
import Foundation.NSURL

// Query service creates Track objects
class Placemarker {
    
    let name: String
    let adventureId: String
    let description: String
    let routeId: String
    let timestamp: Date
    let velocity: String
    let elevation: String
    let location: [Float]
    
    let formatter = ISO8601DateFormatter()
    
    init(name: String, adventureId: String, description: String, routeId: String, timestampString: String, velocity: String, elevation: String, location: [Float]) {
        self.name = name
        self.adventureId = adventureId
        self.description = description
        self.routeId = routeId
        
        self.timestamp = formatter.date(from: timestampString)!
        self.velocity = velocity
        self.elevation = elevation
        self.location = location
    }
    
    
}


