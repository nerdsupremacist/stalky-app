//
//  Geolocation.swift
//  Stalky
//
//  Created by Mathias Quintero on 11/19/17.
//  Copyright © 2017 Jana Pejić. All rights reserved.
//

import CoreLocation
import Sweeft

extension CLLocationManager {
    
    func lookUp() -> Response<String?> {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        guard authorizationStatus != .restricted, authorizationStatus != .denied else {
            return .successful(with: nil)
        }
        guard authorizationStatus != .notDetermined else {
            self.requestWhenInUseAuthorization()
            return .successful(with: nil)
        }
        startUpdatingLocation()
        let location = self.location
        stopUpdatingLocation()
        return location.map { location in
            return .new { setter in
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    let placemark = placemarks?.first
                    let text = placemark?.name ?? placemark?.locality ?? placemark?.country
                    setter.success(with: text)
                }
            }
        } ?? .successful(with: nil)
    }
    
}
