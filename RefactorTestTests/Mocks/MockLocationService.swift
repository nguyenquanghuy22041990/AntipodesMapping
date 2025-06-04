import Foundation
import CoreLocation
@testable import RefactorTest

final class MockLocationService: LocationServiceProtocol {
    var convertToWordsCallCount = 0
    
    var convertToWordsResult: Result<LocationWords, Error> = .success(
        LocationWords(
            words: "test.words.here",
            coordinates: CLLocationCoordinate2D(latitude: 51.520847, longitude: -0.195521)
        )
    )
    
    func convertToWords(coordinates: CLLocationCoordinate2D) async throws -> LocationWords {
        convertToWordsCallCount += 1
        switch convertToWordsResult {
        case .success(let words):
            return LocationWords(words: "test.words.here", coordinates: coordinates)
        case .failure(let error):
            throw error
        }
    }
} 
