#!/bin/bash
# [] required, <> optional
# Usage `bash acme_ssl.sh [domain] <Cloudflare API Key> <Cloudflare Email>`
# Variables: CF_Domain, CF_Key, CF_Email

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

[ $# -eq 0 ] && { echo -e "[] Required, <> Optional\nUsage: bash $0 format [domain] <Cloudflare API Key> <Cloudflare Email>" ; exit 1; }
CF_Domain=$1

if [ $2 ]; then
    CF_Key=$2
fi
if [ $3 ]; then
    CF_Email=$3
fi

echo "Checking acme.sh installation..."
if [ -f "/root/.acme.sh/" ]; then
    echo "acme.sh installed.. Continuing"
else
    apt install -y socat nginx openssl
    curl https://get.acme.sh | sh
    wait
fi

systemctl stop nginx
/root/.acme.sh/acme.sh --issue --standalone -d $CF_Domain --dns dns_cf \
--key-file /etc/letsencrypt/live/$CF_Domain/privkey.pem \
--fullchain-file /etc/letsencrypt/live/$CF_Domain/fullchaim.pem
systemctl start nginx