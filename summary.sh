#!/bin/bash
set -euo pipefail

cat <<EOF

machine is ready!

ip address: $(ip addr show eth0 | perl -n -e'/ inet (\d+(\.\d+)+)/ && print $1')

EOF
