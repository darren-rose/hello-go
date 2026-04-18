APP_NAME=app
BIN_DIR=bin
MAIN_FILE=cmd/app/main.go

# Default target
.DEFAULT_GOAL := build

# Build everything
build: linux windows darwin-amd64 darwin-arm64

# Ensure bin directory exists
init:
	@mkdir -p $(BIN_DIR)

linux: init
	@GOOS=linux GOARCH=amd64 go build -o $(BIN_DIR)/$(APP_NAME)-linux-amd64 $(MAIN_FILE)

windows: init
	@GOOS=windows GOARCH=amd64 go build -o $(BIN_DIR)/$(APP_NAME)-windows-amd64.exe $(MAIN_FILE)

darwin-amd64: init
	@GOOS=darwin GOARCH=amd64 go build -o $(BIN_DIR)/$(APP_NAME)-darwin-amd64 $(MAIN_FILE)

darwin-arm64: init
	@GOOS=darwin GOARCH=arm64 go build -o $(BIN_DIR)/$(APP_NAME)-darwin-arm64 $(MAIN_FILE)

# Clean build artifacts
clean:
	@rm -rf $(BIN_DIR)

# Test build artifacts
test: build
	@echo "Testing build artifacts..."
	@test -f $(BIN_DIR)/$(APP_NAME)-linux-amd64 || (echo "Linux binary missing"; exit 1)
	@test -f $(BIN_DIR)/$(APP_NAME)-windows-amd64.exe || (echo "Windows binary missing"; exit 1)
	@test -f $(BIN_DIR)/$(APP_NAME)-darwin-amd64 || (echo "Darwin AMD64 binary missing"; exit 1)
	@test -f $(BIN_DIR)/$(APP_NAME)-darwin-arm64 || (echo "Darwin ARM64 binary missing"; exit 1)
	@echo "Verifying file types..."
	@file $(BIN_DIR)/$(APP_NAME)-linux-amd64 | grep -q "ELF 64-bit LSB executable" || (echo "Linux binary type incorrect"; exit 1)
	@file $(BIN_DIR)/$(APP_NAME)-windows-amd64.exe | grep -q "PE32+ executable" || (echo "Windows binary type incorrect"; exit 1)
	@file $(BIN_DIR)/$(APP_NAME)-darwin-amd64 | grep -q "Mach-O 64-bit x86_64 executable" || (echo "Darwin AMD64 binary type incorrect"; exit 1)
	@file $(BIN_DIR)/$(APP_NAME)-darwin-arm64 | grep -q "Mach-O 64-bit arm64 executable" || (echo "Darwin ARM64 binary type incorrect"; exit 1)
	@echo "Running Linux binary to verify functionality..."
	@./$(BIN_DIR)/$(APP_NAME)-linux-amd64 | grep -q "Hello, World!" || (echo "Binary output incorrect"; exit 1)
	@echo "All tests passed!"

# Run locally
run:
	@go run $(MAIN_FILE)
