.PHONY: setup
setup:
	dart pub get;

.PHONY: build-runner
build-runner:
	dart run build_runner build --delete-conflicting-outputs

.PHONY: format
format:
	dart format ./lib