//
//  Adventure.swift
//  Adventurlog
//
//  Created by Todd Isaacs on 1/22/18.
//  Copyright © 2018 Todd Isaacs. All rights reserved.
//

import Foundation

class Adventure {
  
    let id: String
    let name: String
    let authorId: String
    let description: String
    let endLocation: [Double]
    let startLocation: [Double]
    var imageURL: String
    
  init(id: String, name: String, authorId: String, description: String, startLocation:[Double], endLocation:[Double], imageURL:String) {
    self.id = id
    self.name = name
    self.authorId = authorId
    self.description = description
    self.endLocation = endLocation
    self.startLocation = startLocation
    self.imageURL = imageURL
  }
    
}
