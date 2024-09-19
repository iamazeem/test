#!/bin/bash

set -eo pipefail

# https://www.oracle.com/database/technologies/instant-client/downloads.html

echo "RUNNER_ENVIRONMENT: $RUNNER_ENVIRONMENT"
echo "RUNNER_OS: $RUNNER_OS"
echo "RUNNER_ARCH: $RUNNER_ARCH"

if [[ $RUNNER_OS == "Linux" && $RUNNER_ARCH == "X64" ]]; then
    echo "[INF] Installing on Linux..."

    URLS=(
    https://download.oracle.com/otn_software/linux/instantclient/instantclient-basic-linuxx64.zip
    https://download.oracle.com/otn_software/linux/instantclient/instantclient-sqlplus-linuxx64.zip
    )

    for URL in "${URLS[@]}"; do
    echo "[INF] Downloading... [$URL]"
    wget -q "$URL"
    done

    INSTALL_BASE_DIR="$GITHUB_WORKSPACE/oracle-instantclient"

    for ZIP in instantclient-*.zip; do
    unzip -q -o "$ZIP" -d "$INSTALL_BASE_DIR"
    done

    INSTALL_DIR_PATH="$(realpath "$INSTALL_BASE_DIR"/instantclient_*)"
    ls -Gghl "$INSTALL_DIR_PATH"

    echo "[INF] Setting path... [$INSTALL_DIR_PATH]"
    echo "$INSTALL_DIR_PATH" >> "$GITHUB_PATH"

    echo "$INSTALL_DIR_PATH" | sudo tee /etc/ld.so.conf.d/oracle-instantclient.conf
    sudo ldconfig

    echo "[INF] Installed successfully!"
elif [[ $RUNNER_OS == "macOS" && $RUNNER_ARCH == "X64" ]]; then
    echo "[INF] Installing on macOS..."

    URLS=(
    https://download.oracle.com/otn_software/mac/instantclient/instantclient-basic-macos.zip
    https://download.oracle.com/otn_software/mac/instantclient/instantclient-sqlplus-macos.zip
    )

    for URL in "${URLS[@]}"; do
    echo "[INF] Downloading... [$URL]"
    wget -q "$URL"
    done

    INSTALL_BASE_DIR="$GITHUB_WORKSPACE/oracle-instantclient"

    for ZIP in instantclient-*.zip; do
    unzip -q -o "$ZIP" -d "$INSTALL_BASE_DIR"
    done

    INSTALL_DIR_PATH="$(realpath "$INSTALL_BASE_DIR"/instantclient_*)"
    ls -Gghl "$INSTALL_DIR_PATH"

    echo "[INF] Setting path... [$INSTALL_DIR_PATH]"
    echo "$INSTALL_DIR_PATH" >> "$GITHUB_PATH"

    echo "[INF] Installed successfully!"
elif [[ $RUNNER_OS == "macOS" && $RUNNER_ARCH == "ARM64" ]]; then
    echo "[INF] Installing on macOS..."

    URLS=(
    https://download.oracle.com/otn_software/mac/instantclient/instantclient-basic-macos-arm64.dmg
    https://download.oracle.com/otn_software/mac/instantclient/instantclient-sqlplus-macos-arm64.dmg
    )

    for URL in "${URLS[@]}"; do
    echo "[INF] Downloading... [$URL]"
    wget -q "$URL"
    done

    ls -Gghl ./*.dmg

    INSTALL_BASE_DIR="$PWD"

    for DMG in instantclient-*.dmg; do
    cd "$INSTALL_BASE_DIR"
    echo "[INF] Mounting... [$DMG]"
    hdiutil mount "$DMG"
    sleep 1
    cd /Volumes/instantclient-*
    echo "[INF] Running install script..."
    ./install_ic.sh
    echo "[INF] Unmounting..."
    hdiutil unmount /Volumes/instantclient-* -force
    done

    INSTALL_DIR_PATH="$(realpath /Users/runner/Downloads/instantclient_*)"
    ls -Gghl "$INSTALL_DIR_PATH"

    echo "[INF] Setting path... [$INSTALL_DIR_PATH]"
    echo "$INSTALL_DIR_PATH" >> "$GITHUB_PATH"

    echo "[INF] Installed successfully!"
elif [[ $RUNNER_OS == "Windows" && $RUNNER_ARCH == "X86" ]]; then
    echo "[INF] Installing on Windows..."
    choco install wget --no-progress

    URLS=(
    https://download.oracle.com/otn_software/nt/instantclient/instantclient-basic-nt.zip
    https://download.oracle.com/otn_software/nt/instantclient/instantclient-sqlplus-nt.zip
    )

    for URL in "${URLS[@]}"; do
    echo "[INF] Downloading... [$URL]"
    wget -q "$URL"
    done

    INSTALL_BASE_DIR="$GITHUB_WORKSPACE/oracle-instantclient"

    for ZIP in instantclient-*.zip; do
    unzip -q -o "$ZIP" -d "$INSTALL_BASE_DIR"
    done

    INSTALL_DIR_PATH="$(realpath "$INSTALL_BASE_DIR"/instantclient_*)"
    ls -Gghl "$INSTALL_DIR_PATH"

    echo "[INF] Setting path... [$INSTALL_DIR_PATH]"
    echo "$INSTALL_DIR_PATH" >> "$GITHUB_PATH"

    echo "[INF] Installed successfully!"
elif [[ $RUNNER_OS == "Windows" && $RUNNER_ARCH == "X64" ]]; then
    echo "[INF] Installing on Windows..."
    choco install wget --no-progress

    URLS=(
    https://download.oracle.com/otn_software/nt/instantclient/instantclient-basic-windows.zip
    https://download.oracle.com/otn_software/nt/instantclient/instantclient-sqlplus-windows.zip
    )

    for URL in "${URLS[@]}"; do
    echo "[INF] Downloading... [$URL]"
    wget -q "$URL"
    done

    INSTALL_BASE_DIR="$GITHUB_WORKSPACE/oracle-instantclient"

    for ZIP in instantclient-*.zip; do
    unzip -q -o "$ZIP" -d "$INSTALL_BASE_DIR"
    done

    INSTALL_DIR_PATH="$(realpath "$INSTALL_BASE_DIR"/instantclient_*)"
    ls -Gghl "$INSTALL_DIR_PATH"

    echo "[INF] Setting path... [$INSTALL_DIR_PATH]"
    echo "$INSTALL_DIR_PATH" >> "$GITHUB_PATH"

    echo "[INF] Installed successfully!"
else
    echo "[ERR] Unsupported OS and/or architecture! [$RUNNER_OS|$RUNNER_ARCH]"
    exit 1
fi
