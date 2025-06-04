//
//  AntipodesMapViewModel.swift
//  RefactorTest
//
//  Created by Huy Quang Nguyen on 6/6/25
//

import Foundation
import CoreLocation
import MapKit
import UIKit

enum MapState: Equatable {
    case idle
    case loading
    case error(String)
    
    static func == (lhs: MapState, rhs: MapState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

struct LocationAnnotation: Equatable {
    let coordinate: CLLocationCoordinate2D
    let words: String
    let color: UIColor
    
    static func == (lhs: LocationAnnotation, rhs: LocationAnnotation) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude &&
               lhs.words == rhs.words &&
               lhs.color == rhs.color
    }
}

final class AntipodesMapViewModel {
    private let getLocationWordsUseCase: GetLocationWordsUseCaseProtocol
    
    @Published private(set) var state: MapState = .idle
    @Published private(set) var primaryLocation: LocationAnnotation?
    @Published private(set) var antipodeLocation: LocationAnnotation?
    
    init(getLocationWordsUseCase: GetLocationWordsUseCaseProtocol) {
        self.getLocationWordsUseCase = getLocationWordsUseCase
    }
    
    func handleLocationSelected(_ coordinate: CLLocationCoordinate2D) async {
        state = .loading
        
        do {
            let result = try await getLocationWordsUseCase.execute(coordinate: coordinate)
            
            primaryLocation = LocationAnnotation(
                coordinate: coordinate,
                words: result.primary.words,
                color: .red
            )
            
            let antipodeCoordinate = CoordinateUtils.getAntipodeCoordinates(for: coordinate)
            antipodeLocation = LocationAnnotation(
                coordinate: antipodeCoordinate,
                words: result.antipode.words,
                color: .blue
            )
            
            state = .idle
        } catch {
            state = .error(error.localizedDescription)
            primaryLocation = nil
            antipodeLocation = nil
        }
    }
    
    func clearLocations() {
        primaryLocation = nil
        antipodeLocation = nil
        state = .idle
    }
} 
