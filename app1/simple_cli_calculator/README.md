# Simple CLI Calculator

A basic command-line interface (CLI) calculator application.

## Description

`simple_cli_calculator` allows you to perform simple arithmetic operations directly from your terminal. It takes two numbers and an operator as command-line arguments and prints the result.

## Features

- Supports basic arithmetic operations:
  - Addition (+)
  - Subtraction (-)
  - Multiplication (\*)
  - Division (/)
- Easy-to-use command-line interface.

**Example (if it's a script like Python or Bash):**

1.  Ensure you have the necessary runtime installed (e.g., Python 3, Bash).
2.  Make the script executable (if needed):
    ```bash
    chmod +x /path/to/your/simple_cli_calculator
    ```

**Example (if it needs compilation like C/C++ or Go):**

1.  Clone the repository (if applicable):
    ```bash
    git clone <your_repository_url>
    cd simple_cli_calculator
    ```
2.  Compile the source code (adjust the command as needed):
    ```bash
    # Example for C
    gcc main.c -o simple_cli_calculator -lm
    # Example for Go
    go build -o simple_cli_calculator main.go
    ```
3.  Place the compiled binary (`simple_cli_calculator`) somewhere in your system's PATH or run it using its full path.

## Usage

Run the calculator from your terminal, providing two numbers and the operator as arguments:

```bash
/path/to/your/simple_cli_calculator <number1> <operator> <number2>
```

**Examples:**

```bash
# Addition
/path/to/your/simple_cli_calculator 5 + 3
# Output: 8

# Multiplication (Note: '*' might need escaping in some shells)
/path/to/your/simple_cli_calculator 6 \* 7
# Output: 42

# Division
/path/to/your/simple_cli_calculator 15 / 4
# Output: 3.75
```
