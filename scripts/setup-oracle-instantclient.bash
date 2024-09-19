#!/bin/bash

set -eo pipefail

# https://www.oracle.com/database/technologies/instant-client/downloads.html

echo "[INF] Installing Oracle Instant Client..."

echo "[INF] RUNNER_ENVIRONMENT: $RUNNER_ENVIRONMENT"
echo "[INF] RUNNER_OS: $RUNNER_OS"
echo "[INF] RUNNER_ARCH: $RUNNER_ARCH"

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

    INSTALL_BASE_DIR="$RUNNER_TEMP/oracle-instantclient"
    echo "[INF] Install directory: $INSTALL_BASE_DIR"

    mkdir -p "$INSTALL_BASE_DIR"
    cd "$INSTALL_BASE_DIR"

    for URL in "${URLS[@]}"; do
        echo "[INF] Downloading... [$URL]"
        wget --quiet "$URL"
    done

    for ZIP in instantclient-*.zip; do
        echo "[INF] Extracting... [$ZIP]"
        unzip -q -o "$ZIP"
    done

    INSTALL_DIR_PATH="$(realpath "$INSTALL_BASE_DIR"/instantclient_*)"
    echo "[INF] INSTALL_DIR_PATH: $INSTALL_DIR_PATH"

    echo "[INF] Setting path... [$INSTALL_DIR_PATH]"
    echo "$INSTALL_DIR_PATH" >>"$GITHUB_PATH"

    echo "[INF] Running ldconfig..."
    echo "$INSTALL_DIR_PATH" | sudo tee /etc/ld.so.conf.d/oracle-instantclient.conf
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

    INSTALL_BASE_DIR="$RUNNER_TEMP/oracle-instantclient"
    echo "[INF] Install directory: $INSTALL_BASE_DIR"

    mkdir -p "$INSTALL_BASE_DIR"
    cd "$INSTALL_BASE_DIR"

    for URL in "${URLS[@]}"; do
        echo "[INF] Downloading... [$URL]"
        wget --quiet "$URL"
    done

    for DMG in instantclient-*.dmg; do
        cd "$INSTALL_BASE_DIR"
        echo "[INF] Mounting... [$DMG]"
        hdiutil mount -quiet "$DMG"
        cd /Volumes/instantclient-*
        echo "[INF] Running install script..."
        ./install_ic.sh
        echo "[INF] Unmounting..."
        hdiutil unmount -force -quiet /Volumes/instantclient-*
    done

    INSTALL_DIR_PATH="$(realpath /Users/"$USER"/Downloads/instantclient_*)"
    echo "[INF] Setting path... [$INSTALL_DIR_PATH]"
    echo "$INSTALL_DIR_PATH" >>"$GITHUB_PATH"
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
    choco install wget --no-progress

    INSTALL_BASE_DIR="$RUNNER_TEMP/oracle-instantclient"
    echo "[INF] Install directory: $INSTALL_BASE_DIR"

    mkdir -p "$INSTALL_BASE_DIR"
    cd "$INSTALL_BASE_DIR"

    for URL in "${URLS[@]}"; do
        echo "[INF] Downloading... [$URL]"
        wget --quiet "$URL"
    done

    for ZIP in instantclient-*.zip; do
        echo "[INF] Extracting... [$ZIP]"
        unzip -q -o "$ZIP"
    done

    INSTALL_DIR_PATH="$(realpath "$INSTALL_BASE_DIR"/instantclient_*)"
    echo "[INF] Setting path... [$INSTALL_DIR_PATH]"
    echo "$INSTALL_DIR_PATH" >>"$GITHUB_PATH"
else
    echo "[ERR] Unsupported OS! [$RUNNER_OS]"
    exit 1
fi

echo "[INF] Installed successfully!"
