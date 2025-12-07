#!/usr/bin/env bash
set -euo pipefail

if ! command -v iwyu_tool.py >/dev/null 2>&1; then
  echo "include-what-you-use not found (install via pip install include-what-you-use or your package manager)." >&2
  exit 1
fi

ROOT_DIR="$(git rev-parse --show-toplevel)"
BUILD_DIR="${IWYU_BUILD_DIR:-$ROOT_DIR/build}"
COMP_DB="$BUILD_DIR/compile_commands.json"

if [ ! -f "$COMP_DB" ]; then
  cat >&2 <<EOM
Missing compile_commands.json at $COMP_DB
Generate it by running, for example:
  cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
EOM
  exit 1
fi

# iwyu_tool.py expects either file paths or runs entire database.
if [ "$#" -eq 0 ]; then
  mapfile -t TARGETS < <(python3 - "$COMP_DB" <<'PY'
import json, pathlib, sys
compdb = json.load(open(sys.argv[1]))
seen = set()
for entry in compdb:
    path = pathlib.Path(entry["file"]).resolve()
    if path not in seen:
        seen.add(path)
        print(path)
PY
  )
else
  TARGETS=()
  for f in "$@"; do
    abs_path="$ROOT_DIR/$f"
    if [ -f "$abs_path" ]; then
      TARGETS+=("$abs_path")
    fi
  done
fi

if [ "${#TARGETS[@]}" -eq 0 ]; then
  echo "No target files supplied to include-what-you-use." >&2
  exit 0
fi

iwyu_tool.py -p "$BUILD_DIR" "${TARGETS[@]}"
