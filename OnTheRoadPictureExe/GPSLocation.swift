//
//  GPSLocation.swift
//  OnTheRoadPictureExe
//
//  Created by JiangYi Zhang on 14/11/19.
//  Copyright (c) 2014年 JiangYi Zhang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class GPSLocation: NSObject, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    var latitude = 0.6
    var longitude = 0.0
    var city = ""
    var zipCode = ""
    var state = ""
    var country = ""
    
    
     override init() {
       
        println(1)
        super.init()
        locationManager = CLLocationManager()
        self.findMyLocation()
        println("\(latitude)")
    }
    
    
    
      func findMyLocation() {
         println("2")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
         println("3")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
         println("4")
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        latitude = locValue.latitude     //经度，注意类型是浮点数
        longitude = locValue.longitude    //纬度，类型是浮点数不是string
        println("latitude: \(latitude) \nlongitude: \(longitude)")
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
        
    }
    
    
    
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            //获取地点信息
            city = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            zipCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            state = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            println(city)   //城市
            println(zipCode)    //邮编
            println(state)      //州
            println(country)    //国家
            /// addMap()
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }

 
    
}
