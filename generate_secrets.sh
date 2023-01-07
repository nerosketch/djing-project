#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


#############################################
# Generate secrets, if it not generated yet
#############################################
if [ ! -d ./secrets ]; then
  mkdir secrets
fi

cd ./secrets

gen_random_passw(){
  local fname="$1"
  if [ ! -f "$fname" ]; then
    local allowed_chars="${2:-'A-Za-z0-9\!\@#\$%\^\&*(-_=+)'}"
    local symbol_len="${3:-64}"
    if [[ ! -s "$fname" ]]; then
      tr -dc "$allowed_chars" < /dev/urandom | head -c "$symbol_len" > "$fname"
    fi
  fi
}

gen_random_passw API_AUTH_SECRET
gen_random_passw DJANGO_SECRET_KEY

if [[ ! -s FIELD_ENCRYPTION_KEY ]]; then
  python3 -c "import os, base64; print(base64.urlsafe_b64encode(os.urandom(32)).decode())" > FIELD_ENCRYPTION_KEY
fi

# FreeRadius default secret
if [[ ! -s RADIUS_SECRET ]]; then
  echo 'testing123' > RADIUS_SECRET
fi

gen_random_passw POSTGRES_PASSWORD "a-z0-9" "12"

gen_random_passw VAPID_PUBLIC_KEY
gen_random_passw VAPID_PRIVATE_KEY

gen_random_passw SORM_EXPORT_FTP_PASSWORD "a-z0-9" "8"

if [ ! -f PAYME_CREDENTIALS ]; then
  touch PAYME_CREDENTIALS
fi

# exit from ./secrets
cd ../