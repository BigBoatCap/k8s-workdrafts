#!/usr/bin/env bash
OS=LINUX
TAG=$(curl -s https://api.github.com/repos/gabeduke/kubectl-iexec/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
curl -LO https://github.com/gabeduke/kubectl-iexec/releases/download/${TAG}/kubectl-iexec_${TAG}_${OS:-Linux}_x86_64.tar.gz
mkdir -p /tmp/kubectl-iexec
tar -xzvf kubectl-iexec_${TAG}_${OS}_x86_64.tar.gz -C /tmp/kubectl-iexec
chmod +x /tmp/kubectl-iexec/kubectl-iexec
sudo mv /tmp/kubectl-iexec/kubectl-iexec /usr/local/bin

if [[ true ]]; then
    cat >> ~/.bashrc << \EOF
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kubectl='minikube kubectl --'
function kubectlgetall {
  for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i

    if [ -z "$1" ]
    then
        kubectl get --ignore-not-found ${i}
    else
        kubectl -n ${1} get --ignore-not-found ${i}
    fi
  done
}
source <(kubectl completion bash)
complete -o default -F __start_kubectl k
EOF
fi
