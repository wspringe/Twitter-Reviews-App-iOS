//
//  ViewController.swift
//  CSE335FinalProject
//
//  Created by Wesley Springer on 4/19/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Fabric
import TwitterKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var location: UITextField!
    
    var locationManager: CLLocationManager! = CLLocationManager()
    let client = TWTRAPIClient()
    var pinTitle = ""
    var pinLocation = ""
    var seguedLat: Double = 0.0
    var seguedLong: Double = 0.0
    
    var pinData:PinData = PinData()
    var pinID:Int64 = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //adding a long press gesture recognizer to the map
        map.delegate = self
        
        //adding gesture recognizer to map
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addPin))
        longPress.minimumPressDuration = 1.5
        map.addGestureRecognizer(longPress)
        
        
        //putting pins on map loaded from CoreData
        let count = pinData.fetchRecord()
        
        if count != 0 {
            for row in 0...count-1 {
                let annotation = MKPointAnnotation()
                let coords = CLLocationCoordinate2D(latitude: pinData.fetchResults[row].lat, longitude: pinData.fetchResults[row].long)
                annotation.coordinate = coords
                annotation.title = pinData.fetchResults[row].title
                annotation.subtitle = pinData.fetchResults[row].subtitle
                self.map.addAnnotation(annotation)
            }
        }
        
        //zoom in on specified place from AllPinsViewController
        if seguedLat != 0.0 && seguedLong != 0.0 {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let coords = CLLocationCoordinate2DMake(seguedLat, seguedLong)
            let region = MKCoordinateRegion(center: coords, span: span)
            self.map.setRegion(region, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //zoom out button shows USA
    @IBAction func zoomOut(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        
        let latUSA = 42.877742
        let longUSA = -97.380979
        
        let coords = CLLocationCoordinate2DMake(latUSA, longUSA)
        
        let span = MKCoordinateSpanMake(50, 50)
        
        let region = MKCoordinateRegionMake(coords, span)
        self.map.setRegion(region, animated: true)
    }
    
    
    @IBAction func findTypedLocation(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        getTypedLocation()
    }

    //get current location
    @IBAction func getCurrentLocation(_ sender: Any) {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
    }
    
    //gets location if typed into textField
    func getTypedLocation ()
    {
        _ = CLGeocoder()
        let addressString = location.text
        CLGeocoder().geocodeAddressString(addressString!, completionHandler:
            {(placemarks, error) in
                
                if error != nil {
                    print("Geocode failed: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
                    let placemark = placemarks![0]
                    let location = placemark.location
                    let coords = location!.coordinate
                    let lat = Int(coords.latitude)
                    let longi = Int(coords.longitude)
                        
                    let span = MKCoordinateSpanMake(0.05, 0.05)
                    let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                    self.map.setRegion(region, animated: true)
                }
                
            })
    }
    
    //for getting user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation:CLLocation = locations.last!
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(0.05, 0.05))
        
        self.map.setRegion(region, animated: true)
        map.showsUserLocation = true
        //Do What ever you want with it
    }
    
    //adds pin to map
    func addPin(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let pt = gestureRecognizer.location(in: map)
            let coord = map.convert(pt, toCoordinateFrom: map)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coord
            
            let alert = UIAlertController(title: "Enter the Title and Location (optional)", message: nil, preferredStyle: .alert)
            alert.addTextField{(textField) in textField.placeholder = "Title"}
            alert.addTextField{(textField) in textField.placeholder = "Location"}
            
            alert.addAction(UIAlertAction(title: "Save Pin", style: .default, handler: {(action) -> Void in
                self.pinTitle = (alert.textFields![0].text)!
                self.pinLocation = (alert.textFields![1].text)!
                annotation.title = self.pinTitle
                annotation.subtitle = self.pinLocation
                self.map.addAnnotation(annotation)
                
                self.pinData.add(t: self.pinTitle, s: self.pinLocation, lat: coord.latitude, long: coord.longitude)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) -> Void in
                return
            }))
            
            present(alert, animated: true)
        }
    }
    
    //customize annotation view for the details symbol
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation {return nil}
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            let calloutButton = UIButton(type: .infoLight)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.sizeToFit()
        }
        else {
            pinView!.annotation = annotation
        }
        
        
        return pinView
    }
    
    //what happens when the info symbol is pressed
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            //created alert at bottom of screen
            let alertController = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            
            let editPin = UIAlertAction(title: "Edit Pin", style: .default) { action in
                let alert = UIAlertController(title: "Edit Title and Location (optional)", message: nil, preferredStyle: .alert)
                alert.addTextField{(textField) in textField.text = (view.annotation?.title)!}
                alert.addTextField{(textField) in textField.text = (view.annotation?.subtitle)!}
                
                alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {(action) -> Void in
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = (view.annotation?.coordinate)!
                    
                    self.pinTitle = (alert.textFields![0].text)!
                    self.pinLocation = (alert.textFields![1].text)!
                    annotation.title = self.pinTitle
                    annotation.subtitle = self.pinLocation
                    
                    self.pinData.edit(t: self.pinTitle, s: self.pinLocation, lat: annotation.coordinate.latitude, long: annotation.coordinate.longitude)
                    
                    self.map.removeAnnotation(view.annotation!)
                    self.map.addAnnotation(annotation)
                    
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) -> Void in
                    return
                }))
                
                self.present(alert, animated: true)

            }
            alertController.addAction(editPin)
            
            //programmatically seguing and passing variables
            let goToTweets = UIAlertAction(title: "See Tweets About Location", style: .default) { action in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TwitterViews") as! TwitterViewController
                vc.lat = "\((view.annotation?.coordinate.latitude)!)"
                vc.long = "\((view.annotation?.coordinate.longitude)!)"
                vc.query = ((view.annotation?.title)!)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
            alertController.addAction(goToTweets)
            
            //programmatically seguing and passing variables
            let goToGoogleWebView = UIAlertAction(title: "Google Location", style: .default) { action in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "GoogleViewController") as! GoogleViewController
                //this is how you pass a variable
                vc.query = ((view.annotation?.title)!)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
            alertController.addAction(goToGoogleWebView)
            
            //deletes annotation at user's request
            let deleteAnnotation = UIAlertAction(title: "Delete Pin", style: .destructive) { action in
                
                let lat = view.annotation?.coordinate.latitude
                let long = view.annotation?.coordinate.longitude
                
                //rounding to 6 decimal places since latitude ot longitude value can have 10+ decimal places, and 6 seems accurate enough

                let index = self.pinData.search(lat: lat!, long: long!)
                self.pinData.delete(row: index)
                self.map.removeAnnotation(view.annotation!)
                
            }
            alertController.addAction(deleteAnnotation)
            
            self.present(alertController, animated: true)
        }
    }
    
    //info button
    @IBAction func infoButton(_ sender: Any) {
        let alert = UIAlertController(title: "How to Use the App", message: "Hold down on spot in the map to add a pin. Tap on any pin to view the title of it and the location you entered. If you press the information button in that view, you will get a list of options to choose from. Each of these options are self-explanatory, and should be easy to use. The 'Get Current Location' button will zoom in on your current location. The 'Find Typed Location' button will try to find the location you enter into the search bar.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Got It!", style: .cancel, handler: {(action) -> Void in
            
        }))
        
        present(alert, animated: true)
    }


}

