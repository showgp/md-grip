.PHONY: build test run macos macos-run macos-test macos-archive macos-dmg macos-candidate macos-candidate-check macos-clean

build:
	go build -o bin/md-grip .

test:
	go test ./...

run:
	go run . $(ARGS)

.PHONY: macos
macos:  ## Build macOS App (MDGrip.app, ad-hoc signed development build)
	xcodebuild -project macos/MDGrip.xcodeproj -scheme MDGrip \
	  -configuration Release -derivedDataPath macos/.build/DerivedData build

.PHONY: macos-run
macos-run:  ## Build and run macOS App in Debug mode
	xcodebuild -project macos/MDGrip.xcodeproj -scheme MDGrip \
	  -configuration Debug -derivedDataPath macos/.build/DerivedData build
	open macos/.build/DerivedData/Build/Products/Debug/MDGrip.app

.PHONY: macos-test
macos-test:  ## Run macOS host adapter behavior tests (real Go, logic test bundle)
	mkdir -p macos/.build/test
	go build -o macos/.build/test/md-grip .
	rm -rf /tmp/mdgrip-managed-test-tool
	mkdir -p /tmp/mdgrip-managed-test-tool/MDGrip.app/Contents/MacOS
	cp macos/.build/test/md-grip /tmp/mdgrip-managed-test-tool/MDGrip.app/Contents/MacOS/md-grip
	xcodebuild -project macos/MDGrip.xcodeproj -scheme MDGrip \
	  -configuration Debug -destination 'platform=macOS' \
	  -derivedDataPath macos/.build/DerivedData test

CANDIDATE_BUILD := macos/.build
CANDIDATE_ARCHS := arm64 x86_64
CANDIDATE_DIR := $(CANDIDATE_BUILD)/candidate

.PHONY: macos-archive
macos-archive:  ## Archive the per-architecture candidate apps (Release, ad-hoc signed)
	@set -e; for arch in $(CANDIDATE_ARCHS); do \
	  echo "Archiving MDGrip-$$arch..."; \
	  rm -rf "$(CANDIDATE_BUILD)/MDGrip-$$arch.xcarchive"; \
	  xcodebuild -project macos/MDGrip.xcodeproj -scheme MDGrip \
	    -configuration Release -archivePath "$(CANDIDATE_BUILD)/MDGrip-$$arch.xcarchive" \
	    ARCHS="$$arch" archive; \
	done

.PHONY: macos-dmg
macos-dmg: macos-archive  ## Build the per-architecture candidate DMGs (with /Applications entry)
	@set -e; rm -rf "$(CANDIDATE_DIR)"; mkdir -p "$(CANDIDATE_DIR)"; \
	for arch in $(CANDIDATE_ARCHS); do \
	  app="$(CANDIDATE_BUILD)/MDGrip-$$arch.xcarchive/Products/Applications/MDGrip.app"; \
	  root="$(CANDIDATE_BUILD)/dmg-root-$$arch"; \
	  rm -rf "$$root"; \
	  mkdir -p "$$root"; \
	  ditto "$$app" "$$root/MDGrip.app"; \
	  ln -sfn /Applications "$$root/Applications"; \
	  hdiutil create -volname "MDGrip" -srcfolder "$$root" -ov -format UDZO "$(CANDIDATE_DIR)/MDGrip-$$arch.dmg"; \
	  rm -rf "$$root"; \
	done

.PHONY: macos-candidate
macos-candidate: macos-dmg  ## Build both candidate DMGs, then verify signatures and architectures
	"$(MAKE)" macos-candidate-check

.PHONY: macos-candidate-check
macos-candidate-check:  ## Verify the archived candidates: ad-hoc signatures, identifiers, per-architecture binaries
	@set -e; for arch in $(CANDIDATE_ARCHS); do \
	  case "$$arch" in arm64) other=x86_64 ;; x86_64) other=arm64 ;; *) echo "unsupported candidate arch: $$arch"; exit 1 ;; esac; \
	  app="$(CANDIDATE_BUILD)/MDGrip-$$arch.xcarchive/Products/Applications/MDGrip.app"; \
	  test -d "$$app" || { echo "missing archived app: $$app"; exit 1; }; \
	  codesign --verify --strict "$$app"; \
	  codesign --verify --strict "$$app/Contents/MacOS/md-grip"; \
	  codesign -dv "$$app" 2>&1 | grep -qx "Identifier=com.showgp.MDGrip"; \
	  codesign -dv "$$app/Contents/MacOS/md-grip" 2>&1 | grep -qx "Identifier=com.showgp.MDGrip.md-grip"; \
	  codesign -dv "$$app" 2>&1 | grep -q "Signature=adhoc"; \
	  codesign -dv "$$app/Contents/MacOS/md-grip" 2>&1 | grep -q "Signature=adhoc"; \
	  for binary in "$$app/Contents/MacOS/MDGrip" "$$app/Contents/MacOS/md-grip"; do \
	    lipo "$$binary" -verify_arch "$$arch" || { echo "missing $$arch: $$binary"; exit 1; }; \
	    if lipo "$$binary" -verify_arch "$$other" 2>/dev/null; then \
	      echo "unexpected $$other slice in $$binary (candidate must contain $$arch only)"; exit 1; \
	    fi; \
	  done; \
	  echo "candidate checks passed: $$app"; \
	done

.PHONY: macos-clean
macos-clean:  ## Clean macOS build artifacts
	rm -rf macos/.build
