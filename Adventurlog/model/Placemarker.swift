//
//  Placemarker.swift
//  Adventurlog
//
//  Created by Todd Isaacs on 1/23/18.
//  Copyright © 2018 Todd Isaacs. All rights reserved.
//

import Foundation

struct Placemarker: Codable {
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case name
    case description
    case routeId
    case adventureId = "adventure"
    case timestamp
    case velocity
    case elevation
    case location
  }
  
  
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    let defaultLocaleIdentifier = "en_US_POSIX"
    let locale = Locale(identifier: defaultLocaleIdentifier)
    formatter.locale = locale
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
    
    return formatter
  }()
  
  static let decoder:JSONDecoder = {
    let _decoder = JSONDecoder()
    _decoder.dateDecodingStrategy = .formatted(Placemarker.dateFormatter)
    
    return _decoder
  }()
  
  static let encoder:JSONEncoder = {
    let _encoder = JSONEncoder()
    _encoder.dateEncodingStrategy = .formatted(Placemarker.dateFormatter)
    
    return _encoder
  }()
  
  
  // PROPERTIES
  let id: String
  let name: String
  let description: String
  let routeId: String?
  let adventureId: String
  let timestamp: Date?
  let velocity: String?
  let elevation: String?
  let location: Location
  
  static func decodePlaceMark(json: String) -> Placemarker? {
    var placemark:Placemarker?
    do {
      placemark = try Placemarker.decoder.decode(Placemarker.self, from:json.data(using: .utf8)!)
    } catch {
      print("error" + error.localizedDescription)
    }
    
    return placemark
  }
  
  static func decodePlaceMarks(jsonData: Data) -> [Placemarker]? {
    var placemarks:[Placemarker]?
    do {
      placemarks = try Placemarker.decoder.decode([Placemarker].self, from:jsonData)
    } catch {
      print("error" + error.localizedDescription)
    }
    
    return placemarks
  }
  
  
  static func encodePlacemark(marker: Placemarker) -> Data? {
    var jsonData: Data?
    do {
      jsonData = try Placemarker.encoder.encode(marker)
    } catch {
      print(error.localizedDescription)
    }
    
    return jsonData
  }
}

enum GeoJSONType : String, Codable {
  case Point
  case LineString
  case Polygon
  case MultiPoint
  case MultiLineString
  case MultiPolygon
  case GeometryCollection
}

struct Location: Codable {
  let coordinates: [Double]
  let type: GeoJSONType
}
