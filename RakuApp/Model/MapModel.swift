//
//  LocationModel.swift
//  RakuApp
//
//  Created by student on 27/05/25.
//

import Foundation
import MapKit

struct MapModel: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem

    var coordinate: CLLocationCoordinate2D {
        mapItem.placemark.coordinate
    }

    var name: String {
        mapItem.name ?? "Unknown Location"
    }
}
