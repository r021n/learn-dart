# Todo CLI App

A simple command-line interface (CLI) application built with Dart for managing your tasks directly from the terminal.

## Features

- **Add Todos:** Add new tasks with descriptions, categories, priorities (Low, Medium, High), and optional due dates.
- **List Todos:** View all your saved tasks.
- **Sort Todos:** Sort the task list by:
  - Due Date (Ascending/Descending)
  - Creation Date (Ascending/Descending)
  - Priority (Ascending/Descending)
- **Filter Todos:** Filter tasks by category or status (Done/Pending).
- **Toggle Status:** Mark tasks as done or revert them back to pending.
- **Remove Todos:** Delete tasks you no longer need.
- **Persistent Storage:** Your tasks are saved locally in a JSON file, so they persist between sessions.

## Prerequisites

- **Dart SDK:** You need to have the Dart SDK installed on your system. You can verify your installation by running:
  ```bash
  dart --version
  ```
  If you don't have it, follow the installation guide on the [official Dart website](https://dart.dev/get-dart).

## Getting Started

1.  **Navigate to the project directory:**
    Open your terminal or command prompt and change the directory to where you have the project files:

    ```bash
    cd "<your-directory-path>"
    ```

2.  **Run the application:**
    Execute the main Dart file using the Dart runtime:
    ```bash
    dart run bin/todo_cli_app.dart
    ```

## Usage

Once the application starts, you will be presented with a menu of options:

```
===== Aplikasi Todo List =====
1. Lihat Semua Todo
2. Tambah Todo Baru
3. Tandai Todo (Selesai/Belum)
4. Hapus Todo
5. Keluar
Pilih opsi (1-5):
```

Simply enter the number corresponding to the action you want to perform and follow the on-screen prompts.

When viewing todos, you'll be asked for sorting and filtering preferences.
