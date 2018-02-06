//
//  MapViewController.swift
//  Adventurlog
//
//  Created by Todd Isaacs on 1/23/18.
//  Copyright © 2018 Todd Isaacs. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

  lazy var mapView: GMSMapView = {
    let _mapView = GMSMapView(frame: .init(x: 0, y: 0, width: 110, height: 200))
    _mapView.translatesAutoresizingMaskIntoConstraints = false
    _mapView.settings.rotateGestures = false
    _mapView.delegate = self
    
    self.view.addSubview(_mapView)
    
    return _mapView
  }()
  
    
    let defaultLocation = [ -82.292618, 26.698751]
    let defaultZoom = 6
    
    let queryService = QueryService()
    var searchResults: [Adventure] = []

    var placemarks:[Placemarker] = []
    var selectedMarker:GMSMarker?

    
    override func viewDidLoad() {
      layoutMap()
        
        //set initial location
        // TODO - save location as a starting place
        print("moving camera")
        let camera = GMSCameraPosition.camera(withLatitude: 26.698751,
                                              longitude: -82.292618,
                                              zoom: 8)
        self.mapView.animate(to: camera)
    }
    
    private func layoutMap() {
      mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
      mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    private func loadResultsInMap() {
        var markers:[GMSMarker] = []
        
        let boatIconView = BoatMarkerView()
        boatIconView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        boatIconView.backgroundColor = UIColor.clear
        
        for adventure in self.searchResults {
            let marker = GMSMarker()
            
            marker.position = CLLocationCoordinate2D( latitude: adventure.startLocation[1], longitude: adventure.startLocation[0])
            marker.iconView = boatIconView
            marker.title = adventure.name
            marker.snippet = adventure.description
            marker.userData = adventure.id
            marker.map = self.mapView
          
            markers.append(marker)
        }
    }
}

extension MapViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("marker tapped")
        if (selectedMarker != nil) {
            selectedMarker?.icon = GMSMarker.markerImage(with: .red)
        }
        selectedMarker = marker;
        marker.icon = GMSMarker.markerImage(with: .black)
        mapView.selectedMarker = marker
      
        //get placemarks
        let adventureId = marker.userData as! String
        queryService.getPlaceholdersFor(adventureId: adventureId) { results, errorMessage in
          
          if let results = results {
            self.placemarks = results
            print("Total placemarkers \(results.count)")
            //self.mapView.clear()
            //self.loadResultsInMap()
          }
          
          if !errorMessage.isEmpty {
            print("Search error: " + errorMessage)
            
          }
        }
      
        return true;
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      print("mapview idleAt")
        let upperRight = self.mapView.projection.visibleRegion().farRight
        let lowerLeft = self.mapView.projection.visibleRegion().nearLeft
        
        queryService.mapSearchWithinArea(lngLowerLeft: lowerLeft.longitude, latLowerLeft: lowerLeft.latitude, lngUpperRight: upperRight.longitude, latUpperRight: upperRight.latitude) { results, errorMessage in
            
            if let results = results {
                self.searchResults = results
                self.mapView.clear()
                self.loadResultsInMap()
            }

            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
                
            }
        }
    }
}
