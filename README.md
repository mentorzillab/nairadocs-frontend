# N-Docs - Nigerian Document Verification App

A Flutter application for secure Nigerian document verification with a clean, modern interface.

## Features

- **Secure Document Upload**: Upload and verify Nigerian documents safely
- **Fast Verification**: Quick processing of document verification requests
- **Clean UI**: Modern design with Material 3 and Google Fonts (Inter)
- **Dashboard**: Track document status (In Review, Approved, Rejected)
- **Profile Management**: User account and settings management
- **Responsive Design**: Works across different screen sizes

## Supported Documents

- National Identification Number (NIN)
- Bank Verification Number (BVN)
- WAEC Certificates
- JAMB Results
- Driver's License
- International Passport

## Architecture

This app follows Clean Architecture principles with:

- **BLoC Pattern**: For state management
- **Dependency Injection**: Using GetIt and Injectable
- **Feature-based Structure**: Organized by features
- **Repository Pattern**: For data layer abstraction

## Design System

- **Primary Color**: #00B3A6 (Teal)
- **Typography**: Inter font family via Google Fonts
- **Material 3**: Modern Material Design components
- **Color Scheme**: Professional teal-based palette

## Getting Started

### Prerequisites

- Flutter SDK (3.5.4 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/mentorzillab/nairadocs-frontend.git
cd nairadocs-frontend/ndocs_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Running Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_strings.dart
│   ├── errors/
│   ├── network/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── dashboard/
│   ├── documents/
│   └── profile/
├── injection/
│   ├── injection.dart
│   └── injection.config.dart
└── main.dart
```

## Dependencies

### Core Dependencies
- `flutter_bloc`: State management
- `go_router`: Navigation
- `google_fonts`: Typography
- `dio`: HTTP client
- `get_it`: Dependency injection

### Development Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Code analysis
- `build_runner`: Code generation

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions or support, please contact the development team.
