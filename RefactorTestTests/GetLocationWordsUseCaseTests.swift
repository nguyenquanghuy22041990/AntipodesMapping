//
//  GetLocationWordsUseCaseTests.swift
//  RefactorTest
//
//  Created by Huy Quang Nguyen on 6/6/25
//

import XCTest
import CoreLocation
@testable import RefactorTest

final class GetLocationWordsUseCaseTests: XCTestCase {
    var sut: GetLocationWordsUseCase!
    var mockLocationService: MockLocationService!
    
    override func setUp() {
        super.setUp()
        mockLocationService = MockLocationService()
        sut = GetLocationWordsUseCase(locationService: mockLocationService)
    }
    
    override func tearDown() {
        sut = nil
        mockLocationService = nil
        super.tearDown()
    }
    
    func test_execute_success() async throws {
        // Given
        let testCoordinate = CLLocationCoordinate2D(latitude: 51.520847, longitude: -0.195521)
        let expectedWords = "test.words.here"
        
        // When
        let result = try await sut.execute(coordinate: testCoordinate)
        
        // Then
        XCTAssertEqual(mockLocationService.convertToWordsCallCount, 2)
        XCTAssertEqual(result.primary.words, expectedWords)
        XCTAssertEqual(result.antipode.words, expectedWords)
        
        // Verify coordinates
        XCTAssertEqual(result.primary.coordinates.latitude, testCoordinate.latitude)
        XCTAssertEqual(result.primary.coordinates.longitude, testCoordinate.longitude)
        
        let expectedAntipodeCoordinate = CoordinateUtils.getAntipodeCoordinates(for: testCoordinate)
        XCTAssertEqual(result.antipode.coordinates.latitude, expectedAntipodeCoordinate.latitude)
        XCTAssertEqual(result.antipode.coordinates.longitude, expectedAntipodeCoordinate.longitude)
    }
    
    func test_execute_error() async {
        // Given
        let testCoordinate = CLLocationCoordinate2D(latitude: 51.520847, longitude: -0.195521)
        let testError = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockLocationService.convertToWordsResult = .failure(testError)
        
        // When/Then
        do {
            _ = try await sut.execute(coordinate: testCoordinate)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(mockLocationService.convertToWordsCallCount, 1)
            XCTAssertEqual(error.localizedDescription, testError.localizedDescription)
        }
    }
} 
