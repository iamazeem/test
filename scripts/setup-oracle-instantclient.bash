#!/bin/bash

set -eo pipefail

echo "[INF] Installing Oracle Instant Client..."

echo "[INF] - RUNNER_ENVIRONMENT: $RUNNER_ENVIRONMENT"
echo "[INF] - RUNNER_OS: $RUNNER_OS"
echo "[INF] - RUNNER_ARCH: $RUNNER_ARCH"

INSTALL_PATH=

if [[ $RUNNER_OS == "Linux" ]]; then
    URLS=()
    if [[ $RUNNER_ARCH == "X86" ]]; then
        URLS=(
            https://download.oracle.com/otn_software/linux/instantclient/instantclient-basic-linux.zip
            https://download.oracle.com/otn_software/linux/instantclient/instantclient-sqlplus-linux.zip
        )
    elif [[ $RUNNER_ARCH == "X64" ]]; then
        URLS=(
            https://download.oracle.com/otn_software/linux/instantclient/instantclient-basic-linuxx64.zip
            https://download.oracle.com/otn_software/linux/instantclient/instantclient-sqlplus-linuxx64.zip
        )
    elif [[ $RUNNER_ARCH == "ARM64" ]]; then
        URLS=(
            https://download.oracle.com/otn_software/linux/instantclient/instantclient-basic-linux-arm64.zip
            https://download.oracle.com/otn_software/linux/instantclient/instantclient-sqlplus-linux-arm64.zip
        )
    else
        echo "[ERR] Unsupported architecture! [$RUNNER_ARCH]"
        exit 1
    fi

    cd "$RUNNER_TEMP"

    for URL in "${URLS[@]}"; do
        echo "[INF] Downloading... [$URL]"
        wget --quiet "$URL"
    done

    for ZIP in instantclient-*.zip; do
        echo "[INF] Extracting... [$ZIP]"
        unzip -q -o "$ZIP"
    done

    rm -rf "$RUNNER_TEMP"/*.zip

    INSTALL_PATH="$(realpath "$RUNNER_TEMP"/instantclient_*)"

    echo "[INF] Running ldconfig..."
    echo "$INSTALL_PATH" | sudo tee /etc/ld.so.conf.d/oracle-instantclient.conf
    sudo ldconfig
elif [[ $RUNNER_OS == "macOS" ]]; then
    URLS=()
    if [[ $RUNNER_ARCH == "X86" || $RUNNER_ARCH == "X64" ]]; then
        URLS=(
            https://download.oracle.com/otn_software/mac/instantclient/instantclient-basic-macos.dmg
            https://download.oracle.com/otn_software/mac/instantclient/instantclient-sqlplus-macos.dmg
        )
    elif [[ $RUNNER_ARCH == "ARM64" ]]; then
        URLS=(
            https://download.oracle.com/otn_software/mac/instantclient/instantclient-basic-macos-arm64.dmg
            https://download.oracle.com/otn_software/mac/instantclient/instantclient-sqlplus-macos-arm64.dmg
        )
    else
        echo "[ERR] Unsupported architecture! [$RUNNER_ARCH]"
        exit 1
    fi

    cd "$RUNNER_TEMP"

    for URL in "${URLS[@]}"; do
        echo "[INF] Downloading... [$URL]"
        wget --quiet "$URL"
    done

    for DMG in instantclient-*.dmg; do
        echo "[INF] Installing... [$DMG]"
        cd "$RUNNER_TEMP"
        hdiutil mount -quiet "$DMG"
        cd /Volumes/instantclient-*
        ./install_ic.sh >/dev/null
        hdiutil unmount -force -quiet /Volumes/instantclient-*
    done

    rm -rf "$RUNNER_TEMP"/*.dmg

    INSTALL_PATH="$(realpath /Users/"$USER"/Downloads/instantclient_*)"
elif [[ $RUNNER_OS == "Windows" ]]; then
    URLS=()
    if [[ $RUNNER_ARCH == "X86" ]]; then
        URLS=(
            https://download.oracle.com/otn_software/nt/instantclient/instantclient-basic-nt.zip
            https://download.oracle.com/otn_software/nt/instantclient/instantclient-sqlplus-nt.zip
        )
    elif [[ $RUNNER_ARCH == "X64" ]]; then
        URLS=(
            https://download.oracle.com/otn_software/nt/instantclient/instantclient-basic-windows.zip
            https://download.oracle.com/otn_software/nt/instantclient/instantclient-sqlplus-windows.zip
        )
    else
        echo "[ERR] Unsupported architecture! [$RUNNER_ARCH]"
        exit 1
    fi

    echo "[INF] Installing wget..."
    if ! choco install wget --no-progress >/dev/null; then
        echo "[ERR] Failed to install wget!"
        exit 1
    fi

    cd "$RUNNER_TEMP"

    for URL in "${URLS[@]}"; do
        echo "[INF] Downloading... [$URL]"
        wget --quiet "$URL"
    done

    for ZIP in instantclient-*.zip; do
        echo "[INF] Extracting... [$ZIP]"
        unzip -q -o "$ZIP"
    done

    rm -rf "$RUNNER_TEMP"/*.zip

    INSTALL_PATH="$(realpath "$RUNNER_TEMP"/instantclient_*)"
else
    echo "[ERR] Unsupported OS! [$RUNNER_OS]"
    exit 1
fi

echo "[INF] Setting PATH... [$INSTALL_PATH]"
echo "$INSTALL_PATH" >>"$GITHUB_PATH"

echo "[INF] Setting output parameter... [install-path]"
echo "install-path=$INSTALL_PATH" >>"$GITHUB_OUTPUT"

echo "[INF] Installed successfully!"
