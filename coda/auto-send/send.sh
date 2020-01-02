#!/bin/bash

# Coda send to echo address

while true; do
    sleep 60
    export CODA_ECHO=tdNDowo9QyHT1KnkQP4173GMona8MdrQ7UbG1E1BxdUgyxAMh9KK2w9tfcBcfxWgQzH29JtZpFZ7MekRtytfR5no6RjdnKdgrx5PByfEXhtZzX3HX74qVEL33qnDfdf6gqMpCxjjgLHECY
    export CODA_PRIVKEY_PASS=123456789
    echo "$(date) sending coda Echo Address"
    /usr/local/bin/coda client send-payment -amount 1 -receiver $CODA_ECHO -fee 1 -privkey-path keys/my-wallet
done
