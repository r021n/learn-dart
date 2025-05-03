# Library CLI App

A simple command-line interface (CLI) application for managing a small library catalog, built with Dart.

## Description

This application allows users to manage a collection of books through a text-based menu. You can add new books, view the existing collection, search for specific books by ISBN, manage borrowing, and return books. The application aims to provide basic library management functionalities directly from your terminal.

Data is automatically loaded when the application starts and saved whenever changes are made (e.g., adding, borrowing, returning a book), ensuring persistence between sessions. (Note: The specific storage mechanism like JSON file handling is implemented within the `LibraryService` class, which is not detailed here).

## Features

- **Add New Book:** Add a book with its ISBN, title, and author.
- **View All Books:** Display a list of all books currently in the library, sorted alphabetically by title.
- **Find Book by ISBN:** Search for a specific book using its unique ISBN.
- **Borrow Book:** Mark a book as borrowed by providing its ISBN and the borrower's name.
- **Return Book:** Mark a borrowed book as available again using its ISBN.
- **Exit:** Save any pending changes (though saving is generally automatic) and close the application.

## Prerequisites

- Dart SDK installed on your system.

**Run the application:**
`bash
    dart run bin/library_cli_app.dart
    `

## Project Structure

```
library_cli_app/
├── bin/                 # Main executable script (library_cli_app.dart)
├── lib/                 # Library code
│   ├── models/          # Data models (e.g., Book class)
│   └── services/        # Business logic (e.g., LibraryService class)
├── pubspec.yaml         # Project dependencies and metadata
└── README.md            # This file
```

---

Feel free to modify or expand this README as your project evolves!
