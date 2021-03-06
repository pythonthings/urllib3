#!/bin/bash

set -exo pipefail

if [[ "$(uname -s)" == "Darwin" && "$NOX_SESSION" == "tests-2.7" ]]; then
    export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin":$PATH
fi

if [ -n "${NOX_SESSION}" ]; then
    if [[ "$(uname -s)" == 'Darwin' ]]; then
        # Explicitly use Python 3.6 on MacOS, otherwise it won't find Nox properly.
        python3.6 -m nox -s "${NOX_SESSION}"
    else
        nox -s "${NOX_SESSION}"
    fi
else
    downstream_script="${TRAVIS_BUILD_DIR}/_travis/downstream/${DOWNSTREAM}.sh"
    if [ ! -x "$downstream_script" ]; then
        exit 1
    fi
    $downstream_script install
    python -m pip install .
    $downstream_script run
fi
