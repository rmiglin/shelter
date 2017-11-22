//
//  Location.swift
//  Alpha
//
//  Created by Karla Padron on 10/30/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import Foundation
import MapKit

class Location: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    //var color: MKAnnotation
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        //self.color = MKPinAnnotationColor.purple
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    var markerTintColor: UIColor  {
        switch discipline {
        case "red":
            return .red
        case "green":
            return .green
        default:
            return .green
        }
    }
    
}

