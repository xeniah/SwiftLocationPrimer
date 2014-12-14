//
//  ViewController.swift
//  SwiftLocationPrimer
//
//  Created by Pugetworks on 12/13/14.
//  Copyright (c) 2014 xeniah. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.showSuccessWithStatus("Oho-ho!");
        // Do any additional setup after loading the view, typically from a nib.
        println("stop here")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findMyLocation(sender: AnyObject) {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        triggerLocationServices()
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            println(locality)
            println(postalCode)
            println(administrativeArea)
            println(country)
        }
    }
    
    // deal with backward compatibility
    func triggerLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            if self.locationManager.respondsToSelector("requestAlwaysAuthorization") {
                locationManager.requestAlwaysAuthorization()
                locationManager.startMonitoringVisits();
            } else {
               locationManager.startUpdatingLocation()
            }
        }
    }
    
    // CLLocationManagerDelegate methods
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .Authorized {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                println("Reverse geocoder failed with error " + error.localizedDescription)
                return
                
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Geocoder failed to resolve")
            }
        })
    }

    // TODO
    func locationManager(manager: CLLocationManager!, didVisit visit: CLVisit!) {
        if visit.departureDate.isEqualToDate(NSDate.distantFuture() as NSDate) {
            // User has arrived, but not left, the location
        } else {
            // The visit is complete
        }
    }

    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        NSLog("Error %@", error.localizedDescription);
        
    }
    
    ////
   // let afmanager = AFHTTPRequestOperationManager()
   


}

