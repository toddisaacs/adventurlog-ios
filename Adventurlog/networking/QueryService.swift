//
//  QueryService.swift
//  Adventurlog
//
//  Created by Todd Isaacs on 1/17/18.
//  Copyright © 2018 Todd Isaacs. All rights reserved.
//

import Foundation


class QueryService {
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Adventure]?, String) -> ()
    typealias PlacemarkerQueryResult = ([Placemarker]?, String) -> ()
  
    let isoDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withTime]

        return formatter
    }()
    
    
    var adventures: [Adventure] = []
    var markers: [Placemarker] = []
    var errorMessage = ""
    
    let server = "https://adventurlog.now.sh"
    let adventure = "/api/adventures"
    let search = "/search/"
    let near = "/near/"
    let within = "/within"
    let placemarkers = "/placemarkers"
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: server + adventure + search) {
            urlComponents.query = "q=\(searchTerm)"
            
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateAdventureSearchResults(data)
                
                    DispatchQueue.main.async {
                        completion(self.adventures, self.errorMessage)
                    }
                }
            }
        
            dataTask?.resume()
        }
    }
    
    func getMapSearchResults(lat: Double, lng: Double, distance: Int, type: String, completion: @escaping QueryResult) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: server + adventure + near) {
            urlComponents.query = "type=\(type)&lat=\(lat)&lng=\(lng)&distance=\(distance)"
            
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateAdventureSearchResults(data)
                    
                    DispatchQueue.main.async {
                        completion(self.adventures, self.errorMessage)
                    }
                }
            }
            
            dataTask?.resume()
        }
    }
    
    func mapSearchWithinArea(lngLowerLeft: Double, latLowerLeft: Double, lngUpperRight: Double, latUpperRight: Double, completion: @escaping QueryResult) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: server + adventure + within) {
            urlComponents.query = "lngLowerLeft=\(lngLowerLeft)&latLowerLeft=\(latLowerLeft)&lngUpperRight=\(lngUpperRight)&latUpperRight=\(latUpperRight)"
            
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateAdventureSearchResults(data)
                    
                    DispatchQueue.main.async {
                        completion(self.adventures, self.errorMessage)
                    }
                }
            }
            
            dataTask?.resume()
        }
    }
  
  func getPlaceholdersFor(adventureId:String, completion: @escaping PlacemarkerQueryResult) {
    dataTask?.cancel()
    
    let placeMarkersUrl = "\(server)\(adventure)/\(adventureId)\(placemarkers)"
    if var urlComponents = URLComponents(string: placeMarkersUrl) {
      
      guard let url = urlComponents.url else { return }
      dataTask = defaultSession.dataTask(with: url) { data, response, error in
        defer { self.dataTask = nil }
        
        if let error = error {
          self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
        } else if let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200 {
          
          if let parseData = Placemarker.decodePlaceMarks(jsonData: data) {
            self.markers = parseData
          }
        
          DispatchQueue.main.async {
            completion(self.markers, self.errorMessage)
          }
        }
      }
      
      dataTask?.resume()
    }
  }
    
    fileprivate func updateAdventureSearchResults(_ data: Data) {
        var response: [Any]?
        adventures.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response as? [JSONDictionary] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        
        var index = 0
        for adventureDictionary in array {
           let imageURL = adventureDictionary["imageURL"] as? String ?? "ocean1"
          
            if let name = adventureDictionary["name"] as? String,
                let id = adventureDictionary["_id"] as? String,
                let authorId = adventureDictionary["author"] as? String,
                let description = adventureDictionary["description"] as? String,
                let created = adventureDictionary["created"] as? String,
                let startLocation = adventureDictionary["startLocation"] as? JSONDictionary,
                let startCoordinates = startLocation["coordinates"] as? [Double],
                let endLocation = adventureDictionary["endLocation"] as? JSONDictionary,
                let endCoordinates = endLocation["coordinates"] as? [Double]
              
                
            {
                print(startCoordinates)
                print(adventureDictionary)
                let timestamp = isoDateFormatter.date(from: created);
                print(isoDateFormatter.string(from: timestamp!));

              adventures.append(Adventure(id: id, name: name, authorId: authorId, description: description, startLocation: startCoordinates, endLocation: endCoordinates, imageURL: imageURL))
                index += 1
            } else {
                errorMessage += "Problem parsing adventures"
            }
        }
    }
}
