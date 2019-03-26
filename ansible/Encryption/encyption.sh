#!/bin/sh
echo "Generate an encryption key..."

ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

echo "Create the encryption-config.yaml encryption config file..."

cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF
echo "Copy the encryption-config.yaml encryption config file ..."

for instance in controller-ines-0 controller-ines-1 controller-ines-2; do
  gcloud compute scp encryption-config.yaml ${instance}:~/
done
