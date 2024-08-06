# Clean Code Architecture with Flutter, BloC in TDD Approach

This is a project that demonstrates how to implement a clean code architecture in Flutter using the Business Logic Component (BloC) pattern and a Test-Driven Development (TDD) approach.

The project is structured according to the principles of clean architecture, with separate layers for presentation, application, domain, and infrastructure. The presentation layer is implemented using Flutter, while the other layers are platform-independent.

The BloC pattern is used to manage the application state and business logic. Each screen in the app has its own BloC, which is responsible for handling user input and updating the UI. The BloCs communicate with the domain layer to perform business logic and with the infrastructure layer to access external services and data sources.

The TDD approach is used to ensure that the code is robust, reliable, and maintainable. Each feature is developed incrementally, with tests written before the code. This helps catch bugs early and ensures that the code is testable, which makes it easier to refactor and maintain over time.

The project includes examples of how to implement common features in Flutter using the BloC pattern, such as navigation, form validation, and data fetch. It also includes unit tests for each feature, demonstrating how to write tests using the Flutter testing framework and the Mockito library.

## Getting Started

To get started with the project, simply clone the repository and run `flutter run` in the project directory. You can also run the tests using the `flutter test` command.

 
