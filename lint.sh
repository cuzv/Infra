#!/usr/bin/env bash

if which swiftlint >/dev/null; then
    swiftlint autocorrect ./Sources
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi