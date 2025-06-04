//
//  W3WLocationService.swift
//  RefactorTest
//
//  Created by Huy Quang Nguyen on 6/6/25
//

import Foundation
import CoreLocation
import W3WSwiftApi

struct W3WSquare {
    let words: String?
    let coordinates: CLLocationCoordinate2D?
}

enum LocationError: Error {
    case conversionFailed(String)
    case invalidCoordinates
    case missingWords
    case missingCoordinates
}

final class W3WLocationService: LocationServiceProtocol {
    private let api: What3WordsV4
    
    init(api: What3WordsV4) {
        self.api = api
    }
    
    convenience init(apiKey: String) {
        self.init(api: What3WordsV4(apiKey: apiKey))
    }
    
    func convertToWords(coordinates: CLLocationCoordinate2D) async throws -> LocationWords {
        return try await withCheckedThrowingContinuation { continuation in
            api.convertTo3wa(coordinates: coordinates, language: W3WBaseLanguage(code: "en")) { square, error in
                if let error = error {
                    continuation.resume(throwing: LocationError.conversionFailed(error.localizedDescription))
                    return
                }
                
                guard let square = square else {
                    continuation.resume(throwing: LocationError.conversionFailed(Strings.Error.noResultFound))
                    return
                }
                
                guard let words = square.words else {
                    continuation.resume(throwing: LocationError.missingWords)
                    return
                }
                
                guard let coordinates = square.coordinates else {
                    continuation.resume(throwing: LocationError.missingCoordinates)
                    return
                }
                
                let result = LocationWords(
                    words: words,
                    coordinates: coordinates
                )
                continuation.resume(returning: result)
            }
        }
    }
} 
