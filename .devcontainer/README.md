# PureScript Deno Core Development Container

This directory contains configuration files to set up a development container for working with the PureScript Deno Core bindings.

## Features

- **Deno**: Pre-installed Deno runtime (v1.43.6) for running TypeScript/JavaScript
- **Node.js and npm**: For PureScript tooling and dependencies
- **VS Code Extensions**:
  - Deno: For Deno language support and tooling
  - GitHub Copilot: For AI-assisted development
  - PureScript: For PureScript language support
  - Prettier: For code formatting

## Getting Started

### Using GitHub Codespaces

1. Click on the "Code" button on the GitHub repository page
2. Select the "Codespaces" tab
3. Click "Create codespace on main"
4. Wait for the environment to be set up

### Using VS Code Remote - Containers

1. Install the [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) extension pack in VS Code
2. Clone the repository: `git clone https://github.com/colinlogue/purescript-deno-core.git`
3. Open the repository in VS Code
4. When prompted, click "Reopen in Container" or run the command "Remote-Containers: Reopen in Container" from the command palette
5. Wait for the container to build and initialize

## Development Workflow

### Building the Project

```bash
# Install dependencies
npm install

# Build the project
npm run build
```

### Running Tests

```bash
# Run all tests
npm test

# Run specific tests
npm test -- --example="specific test pattern"
```

### Project Structure

- `/packages`: Contains the PureScript packages
  - `/deno-runtime`, `/deno-file-system`, etc.: Individual PureScript Deno binding packages
  - `/tests-deno`: Tests for the Deno bindings

## Notes on Deno Integration

This devcontainer is configured specifically for PureScript Deno Core development, allowing:

- Direct access to Deno APIs from PureScript
- Testing PureScript bindings using Deno's runtime
- Integration with VS Code's Deno extension for TypeScript support
- Full Deno permissions within the container for testing IO, network operations, etc.