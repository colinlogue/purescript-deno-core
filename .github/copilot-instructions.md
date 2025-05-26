Make sure to run `npm install` to install all dependencies before running the project.

The TypeScript files will not compile without `npm install` having been run.

Use `npm run build` to build the project.

To run specific tests, use `npm test -- --example="

## Project structure
The root directory is a PureScript workspace.

The [packages](packages) directory contains the PureScript packages.

### Testing
Tests are not located in the individual feature packages, but are written in  dedicated pckage `tests-deno`.

Make sure `npm install` and `npm run build` have been run before running the tests.

Use `npm test` to run the tests.