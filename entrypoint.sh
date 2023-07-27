#!/bin/sh -l

command="$1"
resource="$2"
namespace="$3"
apikey="$4"
apiuri="$5"
parameters="$6"
stdin="$7"
kubectl_version="$8"
testkube_version="$9"

cmdline="kubectl testkube ${command} ${resource}"
if [[ ! -z "$namespace" ]]; then
  cmdline="${cmdline} --namespace ${namespace}"
fi

if [[ ! -z "$apikey" ]]; then
  mkdir .testkube
  echo "{\"oauth2Data\":{\"enabled\":true,\"token\":{\"access_token\":\"$apikey\",\"token_type\":\"bearer\",\"expiry\":\"0001-01-01T00:00:00Z\"}" > .testkube/config.json
fi

if [[ ! -z "$apiuri" ]]; then
  cmdline="${cmdline} --api-uri ${apiuri} --client direct"
fi

if [[ ! -z "$parameters" ]]; then
  cmdline="${cmdline} ${parameters}"
fi

if [[ ! -z "$kubectl_version" ]]; then
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$kubectl_version/bin/linux/amd64/kubectl \
  && chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin
  echo "Installed kubectl version: $kubectl_version"
else
  echo "Kubectl Installation Skipped.."
fi

if [[ ! -z "$testkube_version" ]]; then
  curl -L "https://github.com/kubeshop/testkube/releases/download/v$testkube_version/testkube_$testkube_version_${PLATFORM}.tar.gz" | tar -xzvf - \
  && chmod +x ./kubectl-testkube \
  && mv ./kubectl-testkube /usr/local/bin
  echo "Installed Testkube CLI version: $testkube_version"
else
  echo "Testkube CLI installation skipped.."
fi

status=$?
if [[ $status -eq 1 ]]; then
  exit 1
fi

result="${result//'%'/'%25'}"
result="${result//$'\n'/'%0A'}"
result="${result//$'\r'/'%0D'}"

echo "result=$result" >> $GITHUB_OUTPUT
