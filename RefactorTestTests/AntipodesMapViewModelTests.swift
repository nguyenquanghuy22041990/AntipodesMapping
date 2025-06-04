//
//  AntipodesMapViewModelTests.swift
//  RefactorTest
//
//  Created by Huy Quang Nguyen on 6/6/25
//

import XCTest
import CoreLocation
@testable import RefactorTest

final class MockGetLocationWordsUseCase: GetLocationWordsUseCaseProtocol {
    var executeCallCount = 0
    var executeResult: Result<(primary: LocationWords, antipode: LocationWords), Error> = .success((
        primary: LocationWords(words: "test.words.here", coordinates: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
        antipode: LocationWords(words: "test.words.here", coordinates: CLLocationCoordinate2D(latitude: 0, longitude: 180))
    ))
    
    func execute(coordinate: CLLocationCoordinate2D) async throws -> (primary: LocationWords, antipode: LocationWords) {
        executeCallCount += 1
        switch executeResult {
        case .success(let result):
            return result
        case .failure(let error):
            throw error
        }
    }
}

final class AntipodesMapViewModelTests: XCTestCase {
    var sut: AntipodesMapViewModel!
    var mockUseCase: MockGetLocationWordsUseCase!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockGetLocationWordsUseCase()
        sut = AntipodesMapViewModel(getLocationWordsUseCase: mockUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    func test_handleLocationSelected_success() async {
        // Given
        let testCoordinate = CLLocationCoordinate2D(latitude: 51.520847, longitude: -0.195521)
        let expectedWords = "test.words.here"
        
        // When
        await sut.handleLocationSelected(testCoordinate)
        
        // Then
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
        XCTAssertEqual(sut.primaryLocation?.words, expectedWords)
        XCTAssertEqual(sut.antipodeLocation?.words, expectedWords)
        XCTAssertEqual(sut.state, .idle)
        
        // Verify coordinates
        XCTAssertEqual(sut.primaryLocation?.coordinate.latitude, testCoordinate.latitude)
        XCTAssertEqual(sut.primaryLocation?.coordinate.longitude, testCoordinate.longitude)
        
        let expectedAntipodeCoordinate = CoordinateUtils.getAntipodeCoordinates(for: testCoordinate)
        XCTAssertEqual(sut.antipodeLocation?.coordinate.latitude, expectedAntipodeCoordinate.latitude)
        XCTAssertEqual(sut.antipodeLocation?.coordinate.longitude, expectedAntipodeCoordinate.longitude)
    }
    
    func test_handleLocationSelected_error() async {
        // Given
        let testCoordinate = CLLocationCoordinate2D(latitude: 51.520847, longitude: -0.195521)
        let testError = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockUseCase.executeResult = .failure(testError)
        
        // When
        await sut.handleLocationSelected(testCoordinate)
        
        // Then
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
        XCTAssertNil(sut.primaryLocation)
        XCTAssertNil(sut.antipodeLocation)
        if case .error(let message) = sut.state {
            XCTAssertEqual(message, testError.localizedDescription)
        } else {
            XCTFail("Expected error state")
        }
    }
    
    func test_clearLocations() {
        // Given
        let testCoordinate = CLLocationCoordinate2D(latitude: 51.520847, longitude: -0.195521)
        Task {
            await sut.handleLocationSelected(testCoordinate)
        }
        
        // When
        sut.clearLocations()
        
        // Then
        XCTAssertEqual(sut.state, .idle)
    }
} 
