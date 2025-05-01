# Weather CLI App

A simple command-line interface (CLI) application built with Dart to fetch and display weather information.

## Description

This application allows users to quickly check the current weather conditions for a specified location directly from their terminal.

## Features

- Fetch current weather data (temperature, conditions, etc.) for a given city.
- Simple and easy-to-use command-line interface.

## Prerequisites

- [Dart SDK](https://dart.dev/get-dart) installed.

## Installation

1.  **Clone the repository (if applicable):**
    ```bash
    git clone <your-repository-url>
    cd weather_cli_app
    ```
2.  **Get dependencies:**
    ```bash
    dart pub get
    ```

## Usage

Run the application from your terminal using the `dart run` command, followed by the city name:

```bash
dart run bin/main.dart <city_name>
```

Replace `<city_name>` with the actual name of the city you want to get the weather for (e.g., `London`, `Tokyo`, `New York`).
