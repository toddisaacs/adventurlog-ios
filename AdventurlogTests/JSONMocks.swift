//
//  JSONMock.swift
//  AdventurlogTests
//
//  Created by Isaacs, Todd on 2/3/18.
//  Copyright © 2018 Todd Isaacs. All rights reserved.
//

import Foundation

class JSONMocks {
  static let sharedInstance = JSONMocks()
  
  private init() { }
  
  static let requireWithNullDataPlacemarker = """
      {
        "_id": "5a5cb288afcf39b8a21bdac6",
        "__v": 0,
        "adventure": "5a5cb19e041496b715a17ea6",
        "routeId": "8214b23c-4b16-4c71-a073-852954a30053",
        "name": "Sergio Guerrero (4555718)",
        "description": "",
        "timestamp": null,
        "velocity": null,
        "elevation": "",
        "location": {
          "coordinates": [
          -82.292618,
          26.698751
          ],
          "type": "Point"
        }
      }
    """
  
  static let partialPlacemarker = """
      {
        "_id": "5a5cb288afcf39b8a21bdac6",
        "adventure": "5a5cb19e041496b715a17ea6",
        "name": "Sergio Guerrero (4555718)",
        "description": "",
        "location": {
          "coordinates": [
          -82.292618,
          26.698751
          ],
          "type": "Point"
        }
      }
    """
  
    static var fullPlacemarker = """
      {
        "_id": "5a5cb288afcf39b8a21bdac6",
        "__v": 0,
        "adventure": "5a5cb19e041496b715a17ea6",
        "routeId": "8214b23c-4b16-4c71-a073-852954a30053",
        "name": "Test Name",
        "description": "",
        "timestamp": "2018-01-01T14:18:15.000Z",
        "velocity": "9.0700 km/h",
        "elevation": "26.70 m from MSL",
        "location": {
          "coordinates": [
          -82.292618,
          26.698751
          ],
          "type": "Point"
        }
      }
    """
  
  static let Placemarkers = """
      [
        {
          "_id": "5a5cb288afcf39b8a21bdac6",
          "__v": 0,
          "adventure": "5a5cb19e041496b715a17ea6",
          "routeId": "8214b23c-4b16-4c71-a073-852954a30053",
          "name": "Sergio Guerrero (4555718)",
          "description": "",
          "timestamp": "2018-01-01T14:18:15.000Z",
          "velocity": "9.0700 km/h",
          "elevation": "26.70 m from MSL",
          "location": {
            "coordinates": [
            -82.292618,
            26.698751
            ],
            "type": "Point"
          }
        },
        {
          "_id": "5a5cb288afcf39b8a21bdac7",
          "__v": 0,
          "adventure": "5a5cb19e041496b715a17ea6",
          "routeId": "8214b23c-4b16-4c71-a073-852954a30053",
          "name": "Sergio Guerrero (4555718)",
          "description": "",
          "timestamp": "2018-01-01T14:18:22.000Z",
          "velocity": "9.5 km/h",
          "elevation": "27 m from MSL",
          "location": {
            "coordinates": [
            -82.292633,
            26.698761
            ],
            "type": "Point"
          }
        }
      ]
    """
}


