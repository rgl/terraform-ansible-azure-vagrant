#!/bin/bash
set -euxo pipefail

# NB execute apt-cache madison azure-cli to known the available versions.
azure_cli_version="2.10.1-*"

# install dependencies.
apt-get install -y apt-transport-https gnupg

# install azure-cli.
# see https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
cat >/etc/apt/sources.list.d/azure-cli.list <<EOF
deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main
EOF
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
apt-get update
apt-get install -y azure-cli="$azure_cli_version"
az --version
