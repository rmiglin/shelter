//
//  LocationMarkerView.swift
//  Alpha
//
//  Created by Karla Padron on 11/21/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import Foundation
import MapKit

class LocationMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            guard let location = newValue as? Location else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            // 2
            markerTintColor = location.markerTintColor
            //glyphText = String(describing: location.title!.first!)
        }
    }
}
