# Simple Quiz CLI

A simple command-line interface (CLI) application built with Dart that presents an interactive quiz to the user. Questions are loaded from a local JSON file.

## Features

- Interactive quiz experience directly in your terminal.
- Supports multiple-choice and true/false question types.
- Loads quiz questions dynamically from `data/quiz_questions.json`.

## Prerequisites

- Dart SDK installed on your system.

## Getting Started

1.  **Clone the repository (if you haven't already):**
    If you're getting this project from a repository, clone it first.

    ```bash
    git clone <repository-url>
    cd simple_quiz_cli
    ```

    If you already have the project files, navigate to the project's root directory:

    ```bash
    cd "..\simple_quiz_cli"
    ```

2.  **Ensure dependencies are fetched (if applicable):**
    If your project has dependencies defined in `pubspec.yaml`, run:

    ```bash
    dart pub get
    ```

3.  **Run the application:**
    Execute the main Dart file (assuming it's `bin/simple_quiz_cli.dart` or `bin/main.dart`).
    If your main script is `simple_quiz_cli.dart` in the `bin` folder:
    ```bash
    dart run bin/simple_quiz_cli.dart
    ```
    Or, if it's `main.dart`:
    ```bash
    dart run bin/main.dart
    ```
    The application will then start, loading questions and presenting them to you.

## Quiz Data

The quiz questions are sourced from the `data/quiz_questions.json` file located in the project. This file contains an array of question objects.

Each question object has the following structure:

- `id`: A unique identifier for the question (e.g., `"q1"`).
- `type`: The type of question, such as `"multiple_choice"` or `"true_false"`.
- `text`: The actual text of the question.
- `options` (for `multiple_choice` type): An array of strings representing the possible answers.
- `correctOptionIndex` (for `multiple_choice` type): The zero-based index of the correct answer within the `options` array.
- `correctAnswer` (for `true_false` type): A boolean value (`true` or `false`) indicating the correct answer.

### Example Question Structures:

**Multiple Choice:**

```json
{
  "id": "q1",
  "type": "multiple_choice",
  "text": "Apa ibukota Indonesia?",
  "options": ["Surabaya", "Jakarta", "Bandung", "Medan"],
  "correctOptionIndex": 1
}
```

**True/False:**

```json
{
  "id": "q2",
  "type": "true_false",
  "text": "Matahari terbit dari barat.",
  "correctAnswer": false
}
```

## Project Structure

```
simple_quiz_cli/
├── bin/
│   └── simple_quiz_cli.dart  # Main executable script (or main.dart)
├── data/
│   └── quiz_questions.json   # Quiz questions data
├── lib/
│   └── ...                   # Core application logic (models, services, etc.)
├── pubspec.yaml              # Project metadata and dependencies
└── README.md                 # This file
```

Happy Quizzing!
