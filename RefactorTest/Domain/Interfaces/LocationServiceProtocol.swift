//
//  LocationServiceProtocol.swift
//  RefactorTest
//
//  Created by Huy Quang Nguyen on 6/6/25
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func convertToWords(coordinates: CLLocationCoordinate2D) async throws -> LocationWords
}

struct LocationWords {
    let words: String
    let coordinates: CLLocationCoordinate2D
} 
