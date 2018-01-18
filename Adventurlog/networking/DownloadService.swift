//
//  DownloadService.swift
//  Adventurlog
//
//  Created by Todd Isaacs on 1/17/18.
//  Copyright © 2018 Todd Isaacs. All rights reserved.
//

import Foundation

// Downloads song snippets, and stores in local file.
// Allows cancel, pause, resume download.
class DownloadService {
    
    // SearchViewController creates downloadsSession
    var downloadsSession: URLSession!
    
    // MARK: - Download methods called by TrackCell delegate methods
    
    func startDownload(_ track: Track) {
        // TODO
    }
    // TODO: previewURL is http://a902.phobos.apple.com/...
    // why doesn't ATS prevent this download?
    
    func pauseDownload(_ track: Track) {
        // TODO
    }
    
    func cancelDownload(_ track: Track) {
        // TODO
    }
    
    func resumeDownload(_ track: Track) {
        // TODO
    }
    
}
