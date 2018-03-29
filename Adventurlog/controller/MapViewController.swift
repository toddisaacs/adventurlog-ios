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
    collectionView.isPagingEnabled = false
    collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    collectionView.delegate = self
    collectionView.dataSource = self
    return collectionView
  }()
  
  
  
  let defaultLocation = [ -82.292618, 26.698751]
  let defaultZoom = 6
  
  let queryService = QueryService()
  
  var searchResults: [Adventure] = []
  var searchResultsPlacemarks:[Placemarker] = []

  var markers:[GMSMarker] = []
  var placemarkers:[GMSMarker] = []
  var selectedMarker:GMSMarker?
  
  let cellId = "cellId"
  let cellInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  let cellHeight = CGFloat(170)
  let collectionViewCellOffset = CGFloat(20)
  let collectionViewLineWidth = CGFloat(5)
  
  var collectionViewShowing = false
  
  var currentPageIndex = 0
  var nextPageIndex = 0
  
  var nextCell:AdventureCollectionViewCell?
  var currCell:AdventureCollectionViewCell?
  
  lazy var collectionViewHeightConstraint = adventureCollectionView.heightAnchor.constraint(equalToConstant: 0)
  lazy var collectionViewBottomConstraint = adventureCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
  lazy var collectionViewLeadingConstraint = adventureCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
  lazy var collectionViewTrailingConstraint = adventureCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
  
  
  override func viewDidLoad() {
    view.addSubview(mapView)
    layoutMap()
    
    title = "AdventurLog"
    
    view.addSubview(adventureCollectionView)
    layoutCollectionView()
    
    adventureCollectionView.register(AdventureCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    
    print("moving camera")
    //TODO store users last location
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
    NSLayoutConstraint.activate([collectionViewHeightConstraint, collectionViewBottomConstraint, collectionViewLeadingConstraint, collectionViewTrailingConstraint])
  }
  
  private func showCollectionView() {
    collectionViewShowing = true
    collectionViewHeightConstraint.constant = cellHeight
    
    UIView.animate(withDuration: 0.3,
                   delay: 0.0,
                   options: .curveEaseIn,
                   animations: {
                    self.view.layoutIfNeeded()
                   },
                   completion: nil)
  }
  
  private func hideCollectionView() {
    collectionViewShowing = false
    collectionViewHeightConstraint.constant = 0
    
    UIView.animate(withDuration: 0.3,
                   delay: 0.0,
                   options: .curveEaseIn,
                   animations: {
                    self.view.layoutIfNeeded()
                   },
                   completion: nil)
  }
  
  
  private func loadResultsInMap() {
   
    var selectedMarkerId:String?
    if selectedMarker != nil {
      selectedMarkerId = selectedMarker?.userData as? String
    }
    
    markers.removeAll()
    
    for adventure in self.searchResults {
      let marker = GMSMarker()
      
      marker.position = CLLocationCoordinate2D( latitude: adventure.startLocation[1], longitude: adventure.startLocation[0])
      marker.icon = Styles.imageOfBoatIcon(imageSize: CGSize(width: 28, height: 30),  selected: false, strokeWidth: CGFloat(0.5))

      marker.title = adventure.name
      marker.snippet = adventure.description
      marker.userData = adventure.id
      marker.map = self.mapView
      
      //reselect marker
      if selectedMarkerId != nil && adventure.id == selectedMarkerId {
        setSelectedMarker(marker: marker)
      }
      
      markers.append(marker)
    }
  }
  
  private func loadPlacemarkersInMap() {
    placemarkers.removeAll()
    
    for placemark in searchResultsPlacemarks {
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: placemark.location.coordinates[1], longitude: placemark.location.coordinates[0])
      marker.icon = Styles.imageOfPlacemarker(imageSize: CGSize(width: 3, height: 3))
      marker.userData = placemark.id
      marker.map = self.mapView
      
      placemarkers.append(marker)
    }
  }
  

  private func unSelectMarker() {
    if (selectedMarker != nil) {
      selectedMarker?.icon = Styles.imageOfBoatIcon(imageSize: CGSize(width: 28, height: 30),  selected: false, strokeWidth: CGFloat(0.5))
      selectedMarker = nil
    }
  }
  
  private func setSelectedMarker(marker: GMSMarker) {
    unSelectMarker()
    
    selectedMarker = marker
    marker.icon = Styles.imageOfBoatIcon(imageSize: CGSize(width: 28, height: 30),  selected: true, strokeWidth: CGFloat(0.5))
  }
  
  private func cleanupPlacemarkers() {
    for marker in placemarkers {
      marker.map = nil
    }
    placemarkers.removeAll()
    searchResultsPlacemarks.removeAll()
  }
}

extension MapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    
    //hide infowindow (don't let it show)
    mapView.selectedMarker = nil
    
    cleanupPlacemarkers()
    
    //show collection view
    if (!collectionViewShowing) {
      self.showCollectionView()
    }
   
    setSelectedMarker(marker: marker)
    
    //get placemarks
    let adventureId = marker.userData as! String
    queryService.getPlaceholdersFor(adventureId: adventureId) { results, errorMessage in
      
      if let results = results {
        self.searchResultsPlacemarks = results
        print("Total placemarkers \(results.count)")
        self.loadPlacemarkersInMap()
      }
      
      if !errorMessage.isEmpty {
        print("Search error: " + errorMessage)
        
      }
    }
    
    //scroll to selected cell
    let markerId = marker.userData as! String
    for (index, adventure) in self.searchResults.enumerated() {
      if adventure.id == markerId {
        self.adventureCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        break
      }
    }
    return true;
  }
  
  //This should not hit becuase I'm hiding the info window by not having a "selected" marker on the map, tracking outside of maps
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
        
        if results.count > 0 {
          self.mapView.clear()
          self.loadResultsInMap()
          self.loadPlacemarkersInMap()
          self.adventureCollectionView.reloadData()
        }
        
      }
      
      if !errorMessage.isEmpty {
        print("Search error: " + errorMessage)
        
      }
    }
  }
  
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    print("didTapAt")
    if (collectionViewShowing) {
      hideCollectionView()
    }
    unSelectMarker()
    cleanupPlacemarkers()
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
    
    //adjust map
    let index = Int(page)
    setSelectedMarker(marker: markers[index])
    
    //the start and ending cells don't abide by the targetoffset, the collection view will automatically adjust so cells fill the view
    targetContentOffset.pointee = CGPoint(x: contentOffsetX, y: CGFloat(0))
    
  }
}
