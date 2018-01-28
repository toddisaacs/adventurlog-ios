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
    
    
    let queryService = QueryService()
    var searchResults: [Adventure] = []
    var selectedMarker:GMSMarker?

    
    override func viewDidLoad() {
        mapView.delegate = self
        
        //load Adventures
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        queryService.getMapSearchResults(lat: 26.698751, lng: -82.292618, distance: 100000, type: "Sailing" ) { results, errorMessage in
            
            if let results = results {
                self.searchResults = results
            }
            self.loadResultsInMap()
            
            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
                
            }
        }
    }
    


    
    fileprivate func loadResultsInMap() {
        var bounds = GMSCoordinateBounds()
        var markers:[GMSMarker] = []
        
        for adventure in self.searchResults {
            let marker = GMSMarker()

            marker.position = CLLocationCoordinate2D( latitude: adventure.startLocation[1], longitude: adventure.startLocation[0])
            marker.title = adventure.name
            marker.snippet = adventure.description
            marker.map = self.mapView
            
            markers.append(marker)
        }
        
        for marker in markers {
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        let updatedCamera = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 60, left: 10, bottom: 10, right: 10))
        self.mapView.animate(with: updatedCamera)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
}
