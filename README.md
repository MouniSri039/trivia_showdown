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

**Static code analysis:**

```bash
flutter analyze
```

Result: No issues found.

**Widget tests:**

```bash
flutter test
```

Result: All tests passed.

## Score Synchronization

The application currently uses the classroom score-sync simulation provided by the assignment starter code.

The simulation waits asynchronously, displays a confirmation, and clearly indicates that no backend request was sent.

No actual cloud database or remote leaderboard persistence is implemented. A real score submission would require an instructor-provided endpoint and confirmation from the backend.

## Graduate Critical Thinking

### 1. Offline and Restart Experience

If the app loses its internet connection, I would like it to remember the questions that were already downloaded so that users can still continue playing or start another round without immediately needing an internet connection.

To do this, I would store the last successfully downloaded set of five questions locally using SQLite. I would also save details such as when the questions were downloaded and whether they came from the live API or local storage. This would help the app identify whether the questions are fresh or cached.

When users play with cached questions, I would show a small message saying that they are using offline questions. If the app only has some of the five questions saved, I would not treat them as a complete round. Instead, I would explain that the questions are incomplete and give the user an option to reconnect and try again.

I think this approach is better than making the app completely dependent on an internet connection. However, cached questions might not always be the latest ones, so showing their status and download time is important.

### 2. Local Score History vs. Shared Leaderboard

If I decide to add score history before connecting the app to a real backend, I would store each completed attempt locally using SQLite. Each record could include the score, total number of questions, and the date the round was completed.

I would keep this section separate from a leaderboard and call it **My Local Score History**. I would also clearly mention that these scores are saved only on the user's device and are not uploaded or shared with other players. This would prevent users from thinking that their scores are part of a global ranking.

I would choose SQLite instead of SharedPreferences because score history can contain multiple records, and SQLite is more suitable for storing and managing that kind of data. SharedPreferences would be a simpler option, but it is better for small settings such as user preferences.

One test I would perform is to save a score, turn off the internet, and restart the app. The saved score should still appear under local history, with a clear local-only label. The app should never suggest that the score was uploaded or added to a shared leaderboard.

This approach would let me provide score history even before a backend is available, while keeping the difference between local data and shared results clear.

*Note: These are proposed design improvements for future development. Local question caching and local score history are not currently implemented in this application.*

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

- **Course:** CSC 4360 – Mobile App Development
- **Activity:** In-Class Activity #15 – API-to-Cloud Trivia Showdown
- **Platform:** Flutter and Dart