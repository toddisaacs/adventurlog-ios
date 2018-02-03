//
//  PMarkTests.swift
//  AdventurlogTests
//
//  Created by Isaacs, Todd on 2/1/18.
//  Copyright © 2018 Todd Isaacs. All rights reserved.
//

import Foundation

import XCTest
@testable import Adventurlog

class PMarkTests: XCTestCase {

  
  func testPlaceMarkerJSONEncoding() {
    
    let dateString = "2018-01-01T14:18:15.000Z"
    let timestamp = Placemarker.dateFormatter.date(from: dateString)!
    let location = Location(coordinates: [-82.292618, 26.698751], type: .Point)
    
    let pmark = Placemarker(id: "5a5cb288afcf39b8a21bdac6",
                      name: "Test Name",
                      description: "test",
                      routeId: "8214b23c-4b16-4c71-a073-852954a30053",
                      adventureId: "5a5cb19e041496b715a17ea6",
                      timestamp: timestamp,
                      velocity: "9.0700 km/h",
                      elevation: "26.70 m from MSL",
                      location: location)
    
    if let json = Placemarker.encodePlacemark(marker: pmark) {
      XCTAssertNotNil(json)
      
      //TODO check server compliance with JSON escape \/, for now just replace
      let encodedJson = String(data: json, encoding: .utf8)!.replacingOccurrences(of: "\\/", with: "/")
      //look for relevant JSON fragments since we can't gaurantee order
      XCTAssert(encodedJson.contains("\"_id\":"), "missing JSON key: _id")
      XCTAssert(encodedJson.contains("\"5a5cb288afcf39b8a21bdac6\""), "missing JSON value for key _id")
      XCTAssert(encodedJson.contains("\"adventure\":"), "missing JSON key: adventure")
      XCTAssert(encodedJson.contains("\"5a5cb19e041496b715a17ea6\""), "missing JSON value for key adventure")
      XCTAssert(encodedJson.contains("\"routeId\":"), "missing JSON key: routeId")
      XCTAssert(encodedJson.contains("\"5a5cb19e041496b715a17ea6\""), "missing JSON value for key adventure")
      XCTAssert(encodedJson.contains("\"name\":"), "missing JSON key: name")
      XCTAssert(encodedJson.contains("\"Test Name\""), "missing JSON value for key name")
      XCTAssert(encodedJson.contains("\"description\":"), "missing JSON key: description")
      XCTAssert(encodedJson.contains("\"test\""), "missing JSON value for key description")
      XCTAssert(encodedJson.contains("\"velocity\":"), "missing JSON key: velocity")
      XCTAssert(encodedJson.contains("\"9.0700 km/h\""), "missing JSON value for key velocity")
      XCTAssert(encodedJson.contains("\"elevation\":"), "missing JSON key: elevation")
      XCTAssert(encodedJson.contains("\"26.70 m from MSL\""), "missing JSON value for key elevation")
      XCTAssert(encodedJson.contains("location\":{"), "missing JSON location")
      XCTAssert(encodedJson.contains("coordinates\":[-82.292618000000004,26.698751000000001]"), "missing JSON coordinates")
      XCTAssert(encodedJson.contains("\"type\":\"Point\""), "missing JSON point")
    } else {
      XCTFail()
    }
  }
  
  
  func testFullPlaceMarkerJSONDecoding() {

    let placemark = Placemarker.decodePlaceMark(json: JSONMocks.fullPlacemarker)
    XCTAssertNotNil(placemark)
  
    XCTAssert(placemark!.id == "5a5cb288afcf39b8a21bdac6", "Missing id")
    XCTAssert(placemark!.adventureId == "5a5cb19e041496b715a17ea6", "Missing adventure")
    XCTAssert(placemark!.routeId == "8214b23c-4b16-4c71-a073-852954a30053", "Missing routeId")
    XCTAssert(placemark!.name == "Test Name", "Missing name")
    XCTAssert(placemark!.description == "", "Missing description")
    XCTAssert(placemark!.velocity == "9.0700 km/h", "Missing velocity")
    XCTAssert(placemark!.elevation == "26.70 m from MSL", "Missing elevatin")
    
    XCTAssertNotNil(placemark!.location)
    XCTAssertNotNil(placemark!.location.coordinates)
    XCTAssertNotNil(placemark!.location.type)
    XCTAssert(placemark!.location.coordinates[0] == -82.292618)
    XCTAssert(placemark!.location.coordinates[1] == 26.698751)
    XCTAssert(placemark!.location.type == .Point)
  }
  
  
  func testNullDataPlacemarkerJSONDecoding() {
    
    let placemark = Placemarker.decodePlaceMark(json: JSONMocks.requireWithNullDataPlacemarker)
    XCTAssertNotNil(placemark)
    
    if let placemark = placemark {
      XCTAssert(placemark.id == "5a5cb288afcf39b8a21bdac6", "Missing id")
      XCTAssert(placemark.adventureId == "5a5cb19e041496b715a17ea6", "Missing adventure")
      
      XCTAssertNil(placemark.velocity)
      XCTAssertNil(placemark.timestamp)
      
      XCTAssertNotNil(placemark.location)
      XCTAssertNotNil(placemark.location.coordinates)
      XCTAssertNotNil(placemark.location.type)
      XCTAssert(placemark.location.coordinates[0] == -82.292618)
      XCTAssert(placemark.location.coordinates[1] == 26.698751)
      XCTAssert(placemark.location.type == .Point)
    } else {
      XCTFail()
    }
  }
  
  
  func testPartialPlacemarker() {
    
    let placemark = Placemarker.decodePlaceMark(json: JSONMocks.partialPlacemarker)
    XCTAssertNotNil(placemark)
    
    if let placemark = placemark {
      XCTAssert(placemark.id == "5a5cb288afcf39b8a21bdac6", "Missing id")
      XCTAssert(placemark.adventureId == "5a5cb19e041496b715a17ea6", "Missing adventure")
      
      XCTAssertNil(placemark.velocity)
      XCTAssertNil(placemark.timestamp)
      
      XCTAssertNotNil(placemark.location)
      XCTAssertNotNil(placemark.location.coordinates)
      XCTAssertNotNil(placemark.location.type)
      XCTAssert(placemark.location.coordinates[0] == -82.292618)
      XCTAssert(placemark.location.coordinates[1] == 26.698751)
      XCTAssert(placemark.location.type == .Point)
    } else {
      XCTFail()
    }
  }
}
