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

  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let defaultLocation = [ -82.292618, 26.698751]
    let defaultZoom = 6
    
    let queryService = QueryService()
    var searchResults: [Adventure] = []
    var selectedMarker:GMSMarker?

    
    override func viewDidLoad() {
        mapView.delegate = self
        
        //set initial location
        // TODO - save location as a starting place
        let camera = GMSCameraPosition.camera(withLatitude: 26.698751,
                                              longitude: -82.292618,
                                              zoom: 8)
        self.mapView.animate(to: camera)
    }
    
    
    
    private func loadResultsInMap() {
        var markers:[GMSMarker] = []
        
        for adventure in self.searchResults {
            let marker = GMSMarker()

            marker.position = CLLocationCoordinate2D( latitude: adventure.startLocation[1], longitude: adventure.startLocation[0])
            marker.title = adventure.name
            marker.snippet = adventure.description
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
        
        return true;
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
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
