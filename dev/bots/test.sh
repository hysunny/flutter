#!/bin/bash

export PATH="$PWD/bin:$PWD/bin/cache/dart-sdk/bin:$PATH"

trap detect_error_on_exit EXIT HUP INT QUIT TERM

detect_error_on_exit() {
    exit_code=$?
    set +x
    if [[ $exit_code -ne 0 ]]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Error: script exited early due to error ($exit_code)"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    fi
}

set -ex

# analyze all the Dart code in the repo
flutter analyze --flutter-repo

# verify that the tests actually return failure on failure and success on success
(cd dev/automated_tests; ! flutter test test_smoke_test/fail_test.dart > /dev/null)
(cd dev/automated_tests; flutter test test_smoke_test/pass_test.dart > /dev/null)

# run tests
(cd packages/flutter; flutter test)
(cd packages/flutter_driver; dart -c test/all.dart)
(cd packages/flutter_sprites; flutter test)
(cd packages/flutter_test; flutter test)
(cd packages/flutter_tools; dart -c test/all.dart)

(cd dev/manual_tests; flutter test)
(cd examples/hello_world; flutter test)
(cd examples/layers; flutter test)
(cd examples/stocks; flutter test)
(cd examples/flutter_gallery; flutter test)

# generate and analyze our large sample app
dart dev/tools/mega_gallery.dart
(cd dev/benchmarks/mega_gallery; flutter analyze --watch --benchmark)
