# Antipodes Mapping Application

## Overview
This iOS application demonstrates the concept of antipodes - points on Earth's surface that are diametrically opposite to each other. When a user taps on the map, the app places a red pin at the tap location and a blue pin at its antipode, while displaying the what3words addresses for both locations.

## Architecture and Design Decisions

### MVVM Clean Architecture
The application implements MVVM (Model-View-ViewModel) Clean Architecture, chosen for its:
- Clear separation of concerns
- Enhanced testability
- Scalability
- Maintainability

While MVVM-C (Coordinator) pattern was considered, the current single-screen nature of the app made MVVM sufficient. The architecture is designed to easily accommodate MVVM-C if more screens are added in the future.

### Key Components

1. **Presentation Layer**
   - `AntipodesMapViewController`: Handles UI and user interactions
   - `AntipodesMapViewModel`: Manages UI state and business logic coordination
   - Custom UI components (labels, map annotations)

2. **Domain Layer**
   - `GetLocationWordsUseCase`: Encapsulates core business logic
   - Data models and protocols
   - Clear separation from external dependencies

3. **Data Layer**
   - `W3WLocationService`: Handles communication with what3words API
   - Protocol-based approach for better testability
   - Clean separation of API concerns

### Dependency Management
- Utilized Swinject for dependency injection
- Modular design with clear dependency chain
- Transient scope for use cases
- Proper configuration management

## Code Quality Improvements

### Refactoring and Optimization
1. **Error Handling**
   - Comprehensive error handling throughout the app
   - User-friendly error messages
   - Proper error propagation

2. **Performance**
   - Optimized map interactions
   - Efficient memory management
   - Improved antipode calculation accuracy

3. **UI/UX Enhancements**
   - Custom map annotations with distinct colors
   - Smooth animations for location transitions
   - Clear visual feedback for user actions
   - Added app icons for better visual identity

### Additional Features
- When tapping an annotation, the map zooms to its corresponding antipode
- Automatic cleanup of annotations when tapping a new location
- Smooth animation transitions between locations

## Testing

### Comprehensive Test Coverage
1. **Unit Tests**
   - ViewModel tests with mock dependencies
   - UseCase tests for business logic
   - Location service tests

2. **Mock Objects**
   - Protocol-based mocking
   - Shared mock implementations
   - Consistent test data

### Testing Improvements
- Enhanced assertion coverage
- Better error state testing
- Improved test maintainability

## Localization
- Implemented using `Strings` enum
- Localized user-facing strings
- Support for multiple languages
- Default values for testing environment

## Future Improvements

1. **Feature Enhancements**
   - Offline support
   - Location bookmarking
   - Share functionality
   - Search by what3words address

2. **Architecture Evolution**
   - MVVM-C implementation when adding more screens
   - Enhanced state management
   - Deeper analytics integration

3. **Testing**
   - UI testing expansion
   - Integration tests
   - Performance testing

4. **User Experience**
   - Enhanced animations
   - Accessibility improvements
   - Dark mode support
   - iPad-specific optimizations

## Dependencies
- SnapKit: Modern AutoLayout
- Swinject: Dependency Injection
- W3WSwiftApi: what3words API integration

## Requirements
- iOS 15.6+
- Xcode 15.0+
- Swift 5.0+

## Setup
1. Clone the repository
2. Open `RefactorTest.xcodeproj`
3. Configure your what3words API key in `Configuration.swift`
4. Build and run

