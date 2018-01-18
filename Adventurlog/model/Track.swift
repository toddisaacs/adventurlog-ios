//
//  Track.swift
//  Adventurlog
//
//  Created by Todd Isaacs on 1/17/18.
//  Copyright © 2018 Todd Isaacs. All rights reserved.
//

import Foundation.NSURL

// Query service creates Track objects
class Track {
    
    let name: String
    let artist: String
    let previewURL: URL
    let index: Int
    var downloaded = false
    
    init(name: String, artist: String, previewURL: URL, index: Int) {
        self.name = name
        self.artist = artist
        self.previewURL = previewURL
        self.index = index
    }
    
}
