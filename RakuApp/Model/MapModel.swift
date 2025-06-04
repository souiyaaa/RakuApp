//
//  LocationModel.swift
//  RakuApp
//
//  Created by student on 27/05/25.
//

import Foundation
import MapKit

struct MapModel: Identifiable, Hashable {
    let id = UUID()
    let mapItem: MKMapItem

    var coordinate: CLLocationCoordinate2D {
        mapItem.placemark.coordinate
    }

    var name: String {
        mapItem.name ?? "Unknown Location"
    }

    var address: String {
        // Bisa gunakan placemark.title atau buat formatted address
        mapItem.placemark.title ?? "No address available"
    }

    // Supaya bisa dipakai di ForEach dengan id: \.self, conform ke Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MapModel, rhs: MapModel) -> Bool {
        lhs.id == rhs.id
    }
}

