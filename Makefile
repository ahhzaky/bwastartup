# Go parameters
GOCMD=go
GORUN=$(GOCMD) run
GOMOD=$(GOCMD) mod tidy
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get

# Binary name
BINARY_NAME=service-bwastarup

# Directories
# CMD_DIR=./
# BUILD_DIR=./build

# windows or linux
# ifeq ($(OS),Windows_NT)
# 	CMD_CLEAN=del
# 	EXT=.exe
# else
# 	CMD_CLEAN=rm -f
# 	EXT=
# endif

# run all
all: run

run:
	@echo "Running the application Http..."
	@$(GORUN) main.go

mod:
	@echo "Updating go modules..."
	@$(GOMOD)

.PHONY: run mod