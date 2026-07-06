#!/usr/bin/env bash
set -euo pipefail

/usr/local/bin/provision_ltx23_models.sh

exec /start.sh
