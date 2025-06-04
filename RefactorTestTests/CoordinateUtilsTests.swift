//
//  CoordinateUtilsTests.swift
//  RefactorTest
//
//  Created by Huy Quang Nguyen on 6/6/25
//

import XCTest
import CoreLocation
@testable import RefactorTest

final class CoordinateUtilsTests: XCTestCase {
    // Helper function to compare coordinates with a small margin of error
    private func assertCoordinatesEqual(
        _ first: CLLocationCoordinate2D,
        _ second: CLLocationCoordinate2D,
        accuracy: Double = 0.000001,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(first.latitude, second.latitude, accuracy: accuracy, "Latitude mismatch", file: file, line: line)
        XCTAssertEqual(first.longitude, second.longitude, accuracy: accuracy, "Longitude mismatch", file: file, line: line)
    }
    
    func testAntipodeForZeroZero() {
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        // When
        let antipode = CoordinateUtils.getAntipodeCoordinates(for: coordinate)
        
        // Then
        let expectedAntipode = CLLocationCoordinate2D(latitude: 0, longitude: 180)
        assertCoordinatesEqual(antipode, expectedAntipode)
    }
    
    func testAntipodeForPositiveLatitudeLongitude() {
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: 40.7128, longitude: 74.0060)
        
        // When
        let antipode = CoordinateUtils.getAntipodeCoordinates(for: coordinate)
        
        // Then
        let expectedAntipode = CLLocationCoordinate2D(latitude: -40.7128, longitude: -105.9940)
        assertCoordinatesEqual(antipode, expectedAntipode)
    }
    
    func testAntipodeForNegativeLatitudeLongitude() {
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: -33.8688, longitude: -151.2093)
        
        // When
        let antipode = CoordinateUtils.getAntipodeCoordinates(for: coordinate)
        
        // Then
        let expectedAntipode = CLLocationCoordinate2D(latitude: 33.8688, longitude: 28.7907)
        assertCoordinatesEqual(antipode, expectedAntipode)
    }
    
    func testAntipodeForMaxValues() {
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: 90, longitude: 180)
        
        // When
        let antipode = CoordinateUtils.getAntipodeCoordinates(for: coordinate)
        
        // Then
        let expectedAntipode = CLLocationCoordinate2D(latitude: -90, longitude: 0)
        assertCoordinatesEqual(antipode, expectedAntipode)
    }
    
    func testAntipodeForMinValues() {
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: -90, longitude: -180)
        
        // When
        let antipode = CoordinateUtils.getAntipodeCoordinates(for: coordinate)
        
        // Then
        let expectedAntipode = CLLocationCoordinate2D(latitude: 90, longitude: 0)
        assertCoordinatesEqual(antipode, expectedAntipode)
    }
    
    func testDoubleAntipodeReturnsToOriginal() {
        // Given
        let originalCoordinate = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
        
        // When
        let firstAntipode = CoordinateUtils.getAntipodeCoordinates(for: originalCoordinate)
        let secondAntipode = CoordinateUtils.getAntipodeCoordinates(for: firstAntipode)
        
        // Then
        assertCoordinatesEqual(originalCoordinate, secondAntipode)
    }
} 
