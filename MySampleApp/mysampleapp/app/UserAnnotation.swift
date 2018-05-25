//
//  UserAnnotation.swift
//  MySampleApp
//
//  Created by Bryan Nelson on 11/28/17.
//

import Foundation
import CoreLocation
import MapKit

class UserPointAnnotation:NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var userId: String?
    var cash: Int?
    var latitude: Double?
    var longitude: Double?
    var active: Int?
    
    override init(){
        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}
