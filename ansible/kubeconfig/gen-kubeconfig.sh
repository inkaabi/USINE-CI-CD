#!/bin/sh

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-easy-way5 \
  --region $(gcloud config get-value compute/region) \
  --format 'value(address)')
echo "Generate a kubeconfig file for each worker node...."

for instance in worker-ines-0 worker-ines-1 worker-ines-2; do
  kubectl config set-cluster kubernetes-the-easy-way5 \
    --certificate-authority=../cert/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=../cert/${instance}.pem \
    --client-key=../cert/${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-easy-way5 \
    --user=system:node:${instance} \
    --kubeconfig=${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=${instance}.kubeconfig
if [ ! -f ${instance}.kubeconfig ]; then
  echo " Error generation kubeconfig file"
  exit -1
fi

done
echo "Generate a kubeconfig file for the kube-proxy service..."

kubectl config set-cluster kubernetes-the-easy-way5 \
    --certificate-authority=../cert/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-credentials system:kube-proxy \
    --client-certificate=../cert/kube-proxy.pem \
    --client-key=../cert/kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
if [ ! -f kube-proxy.kubeconfig ]; then
  echo " Error generation kube config for kube-proxy file"
  exit -1
fi
echo "Generate a kubeconfig file for the kube-controller-manager service..."

kubectl config set-cluster kubernetes-the-easy-way5 \
    --certificate-authority=../cert/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=../cert/kube-controller-manager.pem \
    --client-key=../cert/kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-easy-way5 \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
if [ ! -f kube-controller-manager.kubeconfig ]; then
  echo " Error generation kube config file for kube-controller-manager..."
  exit -1
fi
echo "Generate a kubeconfig file for the kube-scheduler service..."

kubectl config set-cluster kubernetes-the-easy-way5 \
    --certificate-authority=../cert/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=../cert/kube-scheduler.pem \
    --client-key=../cert/kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-easy-way5 \
    --user=system:kube-scheduler \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig
if [ ! -f kube-scheduler.kubeconfig ]; then
  echo " Error generation kube config file for kube-scheduler..."
  exit -1
fi
echo "Generate a kubeconfig file for the admin user..."

kubectl config set-cluster kubernetes-the-easy-way5 \
    --certificate-authority=../cert/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=admin.kubeconfig

  kubectl config set-credentials admin \
    --client-certificate=../cert/admin.pem \
    --client-key=../cert/admin-key.pem \
    --embed-certs=true \
    --kubeconfig=admin.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-easy-way5 \
    --user=admin \
    --kubeconfig=admin.kubeconfig

  kubectl config use-context default --kubeconfig=admin.kubeconfig

if [ ! -f admin.kubeconfig ]; then
  echo " Error generation kube config file for admin user..."
  exit -1
fi
echo "Distribute the Kubernetes Configuration Files..."

for instance in worker-ines-0 worker-ines-1 worker-ines-2; do
  gcloud compute scp ${instance}.kubeconfig kube-proxy.kubeconfig ${instance}:~/
done

echo "Copy the appropriate kube-controller-manager and kube-scheduler kubeconfig files to each controller instance..."

for instance in controller-ines-0 controller-ines-1 controller-ines-2; do
  gcloud compute scp admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig ${instance}:~/
done
