#!/usr/bin/env bash
# Toggle MangoWM blur effect using mmsg IPC.
CURRENT=$(mmsg get blur 2>/dev/null || echo "0")
if [[ "$CURRENT" == "1" ]]; then
  mmsg set blur 0
else
  mmsg set blur 1
fi
