//
//  GroupsViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class GroupsViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    // MARK: Instance Variables
    
    var mapView: MKMapView = MKMapView()
    let locationManager = CLLocationManager()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the view controllers background color
        view.backgroundColor = UIColor.whiteColor()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Groups"
        
        // Setup the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Setup the map view
        mapView = MKMapView(frame: self.view.frame)
        mapView.showsUserLocation = true
        mapView.tintColor = Constants.Color.primary
        mapView.showsBuildings = true
        mapView.showsScale = false
        
        // Add the mapview to the view controller
        view.addSubview(mapView)
    
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    // MARK: Location Manager Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        mapView.setRegion(region, animated: false)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
}