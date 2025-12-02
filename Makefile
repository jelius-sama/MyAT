.PHONY: release dev clean

dev:
	@echo "Building for debug mode..."
	@swift build --swift-sdk x86_64-swift-linux-musl
	@echo "Successfully built \`./.build/debug/MyAT\` for debug."

release:
	@echo "Building for release mode..."
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
	swift package reset
