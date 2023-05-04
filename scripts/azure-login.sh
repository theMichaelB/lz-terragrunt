
#!/usr/bin/env bash
set -euo pipefail

# Login into Azure using a service principal
az login --service-principal --username "${ARM_CLIENT_ID}" --password "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}"