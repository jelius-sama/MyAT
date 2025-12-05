.PHONY: release dev clean

pre-build:
	@echo "Getting ready for build..."
	@mkdir -p ./lib
	@musl-go build -buildmode=c-archive -o ./lib/libutils.a ./utils.go
	@mv ./lib/libutils.h ./Sources/Utils/libutils.h
	@echo "Pre-built done!\n"

dev:
	@make pre-build
	@swift build --swift-sdk x86_64-swift-linux-musl
	@echo "Successfully built \`./.build/debug/MyAT\` for debug."
	./.build/debug/MyAT

release:
	@make pre-build
	@mkdir -p ./bin
	@swift build --swift-sdk x86_64-swift-linux-musl -c release \
		-Xswiftc -O \
		-Xswiftc -whole-module-optimization \
		-Xswiftc -cross-module-optimization \
		-Xlinker -s
	@cp ./.build/release/MyAT ./bin/
	@echo "Successfully built \`./bin/MyAT\` for release."

clean:
	@rm -rf ./bin/*
	swift package clean
	swift package reset
