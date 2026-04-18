# hello-go

A minimal Go project with multi-platform build targets and GitHub Actions release automation.

## Project structure

- `cmd/app/main.go` — application entry point
- `Makefile` — builds Linux, Windows, Darwin AMD64, and Darwin ARM64 binaries
- `go.mod` — Go module file (`github.com/darren-rose/hello-go`, Go 1.26.2)
- `.github/workflows/release.yml` — release workflow for tagged builds

## Requirements

- Go 1.26.2
- GNU Make

## Build

Run the default build target to compile all supported binaries:

```sh
make build
```

The binaries are output to `bin/`:

- `bin/app-linux-amd64`
- `bin/app-windows-amd64.exe`
- `bin/app-darwin-amd64`
- `bin/app-darwin-arm64`

## Run locally

To run the app locally without building binaries:

```sh
go run cmd/app/main.go
```

## Test

The Makefile includes a `test` target that:

- builds all binaries
- verifies each binary exists
- checks the binary type with `file`
- runs the Linux binary and confirms the output

```sh
make test
```

## Release automation

A GitHub Actions workflow is configured in `.github/workflows/release.yml`.

When a tag matching `v*` is pushed, the workflow:

1. checks out the repository
2. sets up Go 1.26.2
3. runs `make clean build`
4. creates a GitHub release for the tag
5. uploads the built binaries from `bin/` as release assets

## Notes

- The release workflow requires GitHub Actions permissions for repository contents and package write access.
- The project uses the Makefile as the source of truth for binary creation.
