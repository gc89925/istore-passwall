#!/bin/sh
set -eu

RELEASE_BASE="${1:-https://github.com/gc89925/istore-passwall/releases/latest/download}"
FILENAME="${2:-luci-app-passwall_all.ipk}"
MANIFEST_URL="${3:-}"
TMPDIR="/tmp/passwall-custom-update"
LOGFILE="${TMPDIR}/install.log"
mkdir -p "${TMPDIR}"
: > "${LOGFILE}"

echo "[PassWall Custom Update] start" | tee -a "${LOGFILE}"

install_one() {
  local pkg="$1"
  local url="${RELEASE_BASE}/${pkg}"
  local tmpfile="${TMPDIR}/${pkg}"
  echo "download: ${url}" | tee -a "${LOGFILE}"
  rm -f "${tmpfile}"
  if ! curl -L --fail -o "${tmpfile}" "${url}" >>"${LOGFILE}" 2>&1; then
    echo "[PassWall Custom Update] download failed: ${pkg}" | tee -a "${LOGFILE}"
    return 1
  fi
  if ! opkg install "${tmpfile}" >>"${LOGFILE}" 2>&1; then
    echo "[PassWall Custom Update] install failed: ${pkg}" | tee -a "${LOGFILE}"
    return 1
  fi
  echo "[PassWall Custom Update] installed: ${pkg}" | tee -a "${LOGFILE}"
}

if [ -n "${MANIFEST_URL}" ]; then
  MANIFEST_FILE="${TMPDIR}/manifest.json"
  echo "manifest: ${MANIFEST_URL}" | tee -a "${LOGFILE}"
  if curl -L --fail -o "${MANIFEST_FILE}" "${MANIFEST_URL}" >>"${LOGFILE}" 2>&1; then
    PKGS=$(jsonfilter -i "${MANIFEST_FILE}" -e '@.packages[@]') || PKGS=""
    if [ -n "${PKGS}" ]; then
      for pkg in ${PKGS}; do
        install_one "${pkg}" || exit 1
      done
      echo "[PassWall Custom Update] ok" | tee -a "${LOGFILE}"
      exit 0
    fi
    echo "[PassWall Custom Update] manifest empty, fallback single package" | tee -a "${LOGFILE}"
  else
    echo "[PassWall Custom Update] manifest download failed, fallback single package" | tee -a "${LOGFILE}"
  fi
fi

install_one "${FILENAME}"
echo "[PassWall Custom Update] ok" | tee -a "${LOGFILE}"
