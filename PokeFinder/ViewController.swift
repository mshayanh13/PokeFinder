//
//  ViewController.swift
//  PokeFinder
//
//  Created by Mohammad Hemani on 4/27/17.
//  Copyright © 2017 Mohammad Hemani. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var geoFire: GeoFire!
    var geoFireReference: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        geoFireReference = FIRDatabase.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireReference)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if let loc = userLocation.location, !mapHasCenteredOnce {
            centerMapOnLocation(location: loc)
            mapHasCenteredOnce = true
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "ash")
        }
        
        return annotationView
        
    }
    
    func createSighting(forLocation location: CLLocation, withPokemon pokeId: Int) {
        
        geoFire.setLocation(location, forKey: "\(pokeId)")
        
    }
    
    func showSightingsOnMap(location: CLLocation) {
        let circleQuery = geoFire.query(at: location, withRadius: 2.5)
        
        _ = circleQuery?.observe(.keyEntered, with: { (key, location) in
            
            if let key = key, let location = location {
                let annotation = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
                self.mapView.addAnnotation(annotation)
            }
            
        })
    }
    
    @IBAction func spotRandomPokemon(_ sender: UIButton) {
        
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        let randomNumber = arc4random_uniform(151) + 1
        createSighting(forLocation: location, withPokemon: Int(randomNumber))
        
    }


}

