#!/usr/bin/env bash

function ovn-full-test() {
  # pip install j2cli --user
  # gvm install go1.19 &&  gvm use go1.19
  # go install sigs.k8s.io/kind@v0.11.1
  # curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s -- -b $(go env GOPATH)/bin latest
  # docker-install-buildx
  unset KUBECONFIG
  make release
  make kind-init
  sudo -E make kind-install # 装 cni
  kind-pull-andload-image-in-current kubeovn/pause:3.2  
  kind-pull-andload-image-in-current  kubeovn/agnhost:2.40
  kind-load-image-in-current busybox:stable 
  go install github.com/onsi/ginkgo/v2/ginkgo@latest
  kubectl cluster-info
  sudo mkdir -p /home/runner/.kube/
  sudo cp -r ~/.kube/ /home/runner/.kube/
  sudo chmod -R 777 /home/runner/.kube/
  make e2e
}
