# Contact Manager CLI

A simple command-line interface (CLI) application for managing your contacts.

## Description

`contact_manager_cli` allows you to easily add, view, search, update, and delete contacts directly from your terminal. It's designed to be lightweight and straightforward to use.

## Features

- **Add:** Add new contacts with details like name, phone number, and email.
- **View:** List all saved contacts.
- **Search:** Find specific contacts by name or other criteria.
- **Update:** Modify the details of existing contacts.
- **Delete:** Remove contacts you no longer need.
- **Data Persistence:** Contacts are saved locally (e.g., in a file like CSV, JSON, or a simple database). _(You might want to specify the actual storage method here)_

## Installation

_(Provide specific installation instructions here. Below are common examples, choose/modify as needed)_

**Option 1: Using pip (if packaged)**

```bash
pip install contact_manager_cli
```

**Option 2: From source**

1.  Clone the repository:
    ```bash
    git clone <your-repository-url>
    cd contact_manager_cli
    ```
2.  (Optional) Set up a virtual environment:
    ```bash
    python -m venv venv
    source venv/bin/activate # On Windows use `venv\Scripts\activate`
    ```
3.  Install dependencies (if any):
    ```bash
    pip install -r requirements.txt
    ```

## Usage

_(Provide examples of how to run your application and its commands. Adjust based on your actual commands)_

```bash
# Example: Add a new contact
contact_manager add --name "John Doe" --phone "123-456-7890" --email "john.doe@example.com"

# Example: List all contacts
contact_manager list

# Example: Search for a contact
contact_manager search "John"

# Example: Delete a contact (assuming an ID or unique name is used)
contact_manager delete "John Doe"

# Example: Show help
contact_manager --help
```
