# PureScript Deno Core

## 🚀 Quickstart

```bash
# Install dependencies
npm install

# Build the project
npm run build

# Run all tests
npm test

# Run specific tests (by pattern)
npm test -- --example="FileSystem"
```

## Project Overview

PureScript Deno Core provides idiomatic PureScript bindings to the Deno runtime API. The project aims to:

- Provide type-safe access to Deno functionality from PureScript
- Follow idiomatic patterns for both PureScript and Deno
- Enable seamless interoperability between PureScript and Deno's TypeScript ecosystem
- Create a foundation for building Deno applications in PureScript

## Project Structure

The root directory is a PureScript workspace.

The [packages](packages) directory contains the PureScript packages:
- Individual packages for specific Deno APIs (deno-runtime, deno-file-system, etc.)
- Shared utilities and types
- Testing package

### Testing

Tests are not located in the individual feature packages, but are written in a dedicated package `tests-deno`.

Make sure `npm install` and `npm run build` have been run before running the tests.

## Code Style and Conventions

### PureScript

- Follow standard PureScript naming conventions:
  - Functions and variables in `camelCase`
  - Types, type classes, and constructors in `PascalCase`
  - Modules in `PascalCase` with dot notation for hierarchy
- Document all public functions and types with proper documentation comments
- Organize imports alphabetically
- Use `Effect` for side-effectful operations

### TypeScript (FFI)

- TypeScript files should mirror corresponding PureScript module structures
- Export FFI functions with a leading underscore (e.g., `_functionName`)
- Use proper TypeScript type annotations, especially for FFI functions
- Follow the pattern established in the `purescript.d.ts` file for effect functions
- Keep FFI implementation focused on bridging to Deno APIs only

## Contribution Guidelines

When contributing to this project:

1. Create a branch with a descriptive name related to your changes
2. Ensure all tests pass before submitting a PR
3. Add new tests for new functionality
4. Update documentation to reflect changes
5. Make sure code builds without warnings
6. Keep commits focused and with clear messages
7. For significant changes, discuss in an issue first

### Example Code Pattern

PureScript function with FFI:

```purescript
-- PureScript file (FileSystem.purs)
foreign import _readTextFile :: EffectFn3 StringOrUrl (EffectFn1 String Unit) (EffectFn1 Error Unit) Unit

readTextFile :: forall a. IsStringOrUrl a => a -> Aff String
readTextFile path = makeAff \cb ->
  let
    onSuccess = cb <<< Right
    onFailure = cb <<< Left
  in
    runEffectFn3 _readTextFile (toStringOrUrl path) (mkEffectFn1 onSuccess) (mkEffectFn1 onFailure) *> mempty
```

```typescript
// TypeScript file (FileSystem.ts)
export const _readTextFile: EffectFn3<
  string | URL,
  EffectFn1<string, void>,
  EffectFn1<Error, void>,
  void
> = (path, onSuccess, onError) => {
  Deno.readTextFile(path)
    .then(onSuccess)
    .catch(onError);
};
```