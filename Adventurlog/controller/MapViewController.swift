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
    let _mapView = GMSMapView(frame: .zero)
    _mapView.translatesAutoresizingMaskIntoConstraints = false
    _mapView.settings.rotateGestures = false
    _mapView.delegate = self
  
    return _mapView
  }()
  

  lazy var adventureCollectionView:UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    layout.scrollDirection = .horizontal
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = UIColor.blue
    collectionView.isPagingEnabled = false
    collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    
    collectionView.delegate = self
    collectionView.dataSource = self
    return collectionView
  }()
  
//  lazy var blueBox:UIView = {
//    let view = UIView()
//    view.backgroundColor = UIColor.red
//    view.translatesAutoresizingMaskIntoConstraints = false
//
//    return view
//  }()
  
    let defaultLocation = [ -82.292618, 26.698751]
    let defaultZoom = 6
    
    let queryService = QueryService()
    var searchResults: [Adventure] = []

    var placemarks:[Placemarker] = []
    var selectedMarker:GMSMarker?
  
    let cellId = "cellId"
    let cellInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let cellHeight = CGFloat(170)
    let collectionViewCellOffset = CGFloat(20)
    let collectionViewLineWidth = CGFloat(5)
  
  var currentPageIndex = 0
  var nextPageIndex = 0
  
  var nextCell:AdventureCollectionViewCell?
  var currCell:AdventureCollectionViewCell?
  
    override func viewDidLoad() {
        view.addSubview(mapView)
        layoutMap()
      
        title = "AdventurLog"
      
        view.addSubview(adventureCollectionView)
        layoutCollectionView()
        // adventureCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        adventureCollectionView.register(AdventureCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    
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
  
    private func layoutCollectionView() {
      adventureCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
      adventureCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      adventureCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      adventureCollectionView.heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
    }
  
//  private func layoutBlueBox() {
//    blueBox.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    blueBox.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//    blueBox.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//    blueBox.heightAnchor.constraint(equalToConstant: 125).isActive = true
//  }
  
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

extension MapViewController: GMSMapViewDelegate {
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
               self.adventureCollectionView.reloadData()
            }

            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
                
            }
        }
    }
}

extension MapViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return searchResults.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AdventureCollectionViewCell
    cell.backgroundColor = UIColor.white
    let adventure = searchResults[indexPath.row]
    cell.title.text = "\(adventure.name)"
    let imageName = adventure.imageURL
    cell.imageView.image = UIImage(named: imageName)
   // print("Cell Size \(cell.frame) label Size \(cell.title.frame) contentViewSize: \(cell.contentView.frame)")
    return cell
  }
  
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
}

extension MapViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
    return CGSize(width: adventureCollectionView.frame.width - CGFloat(collectionViewCellOffset * 2) , height: cellHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return collectionViewLineWidth
  }
  
  
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
  
    //Adjust target offset to match nearest page and adjust for offset
    let cellWidth = Float(adventureCollectionView.frame.width) - Float(collectionViewCellOffset * 2)
    
    
    //adjust target offset for page identification to include collectionViewCellOffset otherwise it requires user to scroll way past the 50% mark before paging
    let targetContentOffsetX = Float(targetContentOffset.pointee.x)
    let page = ((targetContentOffsetX + Float(collectionViewCellOffset))/cellWidth).rounded(.toNearestOrEven)
    let contentOffsetX = CGFloat(page * (cellWidth + Float(collectionViewLineWidth)) - Float(collectionViewCellOffset))

    //the start and ending cells don't abide by the targetoffset, the collection view will automatically adjust so cells fill the view
    targetContentOffset.pointee = CGPoint(x: contentOffsetX, y: CGFloat(0))
    
  }
}
