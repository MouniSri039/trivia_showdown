# Cloud Trivia Showdown 

A Flutter-based trivia application built with Dart that fetches live multiple-choice questions from the Open Trivia Database REST API.

## Project Overview

Cloud Trivia Showdown demonstrates how a Flutter application consumes REST API data, handles asynchronous network operations, manages application state, and provides interactive user feedback.

The application fetches five easy multiple-choice questions and allows users to complete a trivia round, view their score, and replay with a new set of questions.

## Features

- **Live API Integration:** Fetches five questions using the Open Trivia Database API.
- **JSON Parsing:** Converts API responses into structured question objects.
- **Text Decoding:** Cleans supported encoded HTML entities in questions and answers.
- **Shuffled Answers:** Randomizes answer choices for each question.
- **Loading State:** Displays a loading indicator while fetching questions.
- **Error Handling:** Handles unsuccessful API responses, connection failures, and request timeouts.
- **Interactive Quiz:** Provides four multiple-choice answers for each question.
- **Answer Feedback:** Highlights correct answers in green and incorrect selections in red.
- **Score Tracking:** Awards points only for the first answer selected per question.
- **Progress Tracking:** Displays question numbers and round progress.
- **Results Screen:** Displays the final score out of five.
- **Score Sync Simulation:** Demonstrates an asynchronous score-submission flow.
- **Replay:** Allows users to start a new round with freshly fetched questions.

## Technology Stack

- Flutter
- Dart
- HTTP package
- Open Trivia Database REST API
- JSON

## API Endpoint

The application uses the following endpoint:

```text
https://opentdb.com/api.php?amount=5&category=9&difficulty=easy&type=multiple
```

The application checks both the HTTP response status and the API response code before processing the returned questions.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Visual Studio Code or Android Studio
- Android emulator or physical Android device
- Internet connection

### Installation

1. Clone the repository:

```bash
git clone https://github.com/MouniSri039/trivia_showdown.git
```

2. Navigate to the project directory:

```bash
cd trivia_showdown
```

3. Install dependencies:

```bash
flutter pub get
```

4. Check connected devices:

```bash
flutter devices
```

5. Run the application:

```bash
flutter run
```

## Testing and Validation

The application was tested on an Android emulator.

The following checks were performed:

- Successfully fetched and displayed five live trivia questions.
- Observed the loading indicator during question retrieval.
- Observed a connection timeout error when the API request did not complete.
- Tested correct and incorrect answer feedback.
- Verified that the correct answer appears in green and an incorrect selected answer appears in red.
- Tested question progression and final score calculation.
- Tested the replay functionality.
- Tested the simulated score synchronization and its confirmation message.

### Validation Commands

Static code analysis:

```bash
flutter analyze
```

Result: No issues found.

Widget tests:

```bash
flutter test
```

Result: All tests passed.

## Score Synchronization

The application currently uses the classroom score-sync simulation provided by the assignment starter code.

The simulation waits asynchronously, displays a confirmation, and clearly indicates that no backend request was sent.

No actual cloud database or remote leaderboard persistence is implemented. A real score submission would require an instructor-provided endpoint and confirmation from the backend.

## Development History

The project was initialized as a Flutter application, followed by HTTP dependency setup and integration of the provided trivia starter code.

Development and verification included:

- REST API question retrieval and JSON parsing.
- Interactive answer selection and score tracking.
- Correct and incorrect answer feedback.
- Results screen, score-sync simulation, and replay.
- Widget test execution and static analysis.
- Git version control and GitHub repository setup.
- README documentation and project setup instructions.

## GitHub Repository

[Cloud Trivia Showdown – GitHub Repository](https://github.com/MouniSri039/trivia_showdown)

## Assignment Information

**Course:** CSC 4360 – Mobile App Development

**Activity:** In-Class Activity #15 – API-to-Cloud Trivia Showdown

**Platform:** Flutter and Dart
