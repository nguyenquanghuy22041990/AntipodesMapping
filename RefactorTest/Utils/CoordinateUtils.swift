//
//  CoordinateUtils.swift
//  RefactorTest
//
//  Created by Huy Quang Nguyen on 6/6/25
//

import Foundation
import CoreLocation

enum CoordinateUtils {
    /// Calculates the antipode (opposite point on Earth) for a given coordinate
    /// - Parameter coordinate: The original coordinate
    /// - Returns: The antipode coordinate
    static func getAntipodeCoordinates(for coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let antipodeLatitude = -coordinate.latitude
        var antipodeLongitude = coordinate.longitude + 180
        
        if antipodeLongitude > 180 {
            antipodeLongitude -= 360
        }
        
        return CLLocationCoordinate2D(latitude: antipodeLatitude, longitude: antipodeLongitude)
    }
} 
