//
//  GetLocationWordsUseCase.swift
//  RefactorTest
//
//  Created by Huy Quang Nguyen on 6/6/25
//

import Foundation
import CoreLocation

protocol GetLocationWordsUseCaseProtocol {
    func execute(coordinate: CLLocationCoordinate2D) async throws -> (primary: LocationWords, antipode: LocationWords)
}

final class GetLocationWordsUseCase: GetLocationWordsUseCaseProtocol {
    private let locationService: LocationServiceProtocol
    
    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
    }
    
    func execute(coordinate: CLLocationCoordinate2D) async throws -> (primary: LocationWords, antipode: LocationWords) {
        // Get primary location words
        let primaryWords = try await locationService.convertToWords(coordinates: coordinate)
        
        // Calculate and get antipode location words
        let antipodeCoordinate = CoordinateUtils.getAntipodeCoordinates(for: coordinate)
        let antipodeWords = try await locationService.convertToWords(coordinates: antipodeCoordinate)
        
        return (primary: primaryWords, antipode: antipodeWords)
    }
} 
