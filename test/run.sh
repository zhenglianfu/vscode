#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
	realpath() { [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"; }
	ROOT=$(dirname $(dirname $(realpath "$0")))
else
	ROOT=$(dirname $(dirname $(readlink -f $0)))
fi

# Unit Tests
if [[ "$OSTYPE" == "darwin"* ]]; then
	cd $ROOT ; ulimit -n 4096 ; ATOM_SHELL_INTERNAL_RUN_AS_NODE=1 \
		../Electron-Build/Electron.app/Contents/MacOS/Electron \
		node_modules/mocha/bin/_mocha $*
else
	cd $ROOT ; ATOM_SHELL_INTERNAL_RUN_AS_NODE=1 \
		../Electron-Build/electron \
		node_modules/mocha/bin/_mocha $*
fi

# Integration Tests (currently not enabled for linux because of missing display)
./scripts/code.sh $ROOT/extensions/vscode-api-tests/testWorkspace --extensionDevelopmentPath=$ROOT/extensions/vscode-api-tests --extensionTestsPath=$ROOT/extensions/vscode-api-tests/out