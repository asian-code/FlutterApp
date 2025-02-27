A modern Flutter application featuring user authentication, data visualization, and app management functionalities with a sleek, gradient-based UI design.

## Overview

A comprehensive mobile application built with Flutter that demonstrates best practices in mobile app architecture, state management, and UI design. The app includes a complete authentication flow, interactive dashboard with data visualization, app management features, and user profile management.

## Features

- **Authentication System**
    - User login and registration with validation
    - Separate customer and employee login flows
    - JWT token-based authentication
    - Secure credential storage

- **Interactive Dashboard**
    - User activity visualization with line charts
    - App usage distribution with interactive pie charts
    - Key metrics display with custom indicators

- **App Management**
    - Installed apps overview in a responsive grid
    - Available services showcase with pricing

- **User Profile**
    - Profile information management
    - Security settings (password change, 2FA options)
    - Account deletion with confirmation flow

- **Modern UI Components**
    - Custom navigation bar with sliding/peeking behavior
    - Gradient buttons and styled text fields
    - Animated transitions between screens
    - Consistent design language throughout the app

## Technical Architecture

The app follows a structured architecture with clear separation of concerns:

```
lib/
├── models/       # Data models
├── repositories/ # Data operations
├── screens/      # UI screens by feature 
├── services/     # Backend services
├── theme/        # Styling definitions
├── utils/        # Utilities and constants
└── widgets/      # Reusable UI components
```

### State Management
- Provider pattern for app-wide state management
- ChangeNotifier for reactive UI updates

### Data Handling
- API Service for backend communication
- Secure Storage for sensitive information
- Model-based data transformation

## Setup and Installation

1. **Prerequisites**
    - Flutter SDK (latest stable version)
    - Dart SDK
    - Android Studio / Xcode

2. **Dependencies**
    - Add the following to your `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     provider: ^6.0.0
     http: ^0.13.4
     flutter_secure_storage: ^5.0.2
     fl_chart: ^0.55.0
   ```

3. **Configuration**
    - Update the API endpoint in `lib/utils/constants.dart` to match your backend service

4. **Running the App**
   ```
   flutter pub get
   flutter run
   ```

## Strengths

1. **Well-Structured Architecture**
    - Clear separation of concerns following software engineering best practices
    - Consistent naming conventions and code organization
    - Modular components that can be reused and tested independently

2. **Comprehensive Authentication**
    - Complete authentication flow with proper validation
    - Secure token storage and handling
    - Error handling and user feedback

3. **Polished UI/UX**
    - Cohesive design language with custom components
    - Smooth animations and transitions
    - Interactive data visualizations
    - Responsive layouts that adapt to different screen sizes

4. **State Management**
    - Effective use of Provider for app-wide state
    - Clean implementation of ChangeNotifier for reactive UI

5. **Code Quality**
    - Thorough documentation with comments
    - Model classes with proper encapsulation
    - Error handling throughout the application

## Areas for Improvement

1. **Testing Coverage**
    - The codebase would benefit from unit, widget, and integration tests
    - Test-driven development approach could improve code reliability

2. **Accessibility Features**
    - Implement screen reader support
    - Add support for dynamic text sizing
    - Improve color contrast for better readability

3. **Offline Support**
    - Implement local caching of data for offline use
    - Add synchronization logic for offline changes

4. **Performance Optimization**
    - Reduce unnecessary rebuilds in the widget tree
    - Implement lazy loading for large datasets
    - Optimize asset loading and memory usage

5. **Internationalization**
    - Add support for multiple languages
    - Implement locale-aware formatting for dates, numbers, etc.

6. **Dependency Injection**
    - Consider using a dedicated DI solution for better testability
    - Reduce singleton usage in favor of more testable patterns

7. **Error Handling Refinement**
    - More granular error messages for API failures
    - Better retry mechanisms for network operations
    - Comprehensive logging system for debugging

8. **Backend API Documentation**
    - Include API documentation or OpenAPI specifications
    - Add examples of expected request/response formats

## Dependencies

- [provider](https://pub.dev/packages/provider): For state management
- [http](https://pub.dev/packages/http): For API communication
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage): For secure data storage
- [fl_chart](https://pub.dev/packages/fl_chart): For interactive charts

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request