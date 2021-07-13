#!/usr/bin/env bash
#
# From https://dev.to/jaysonsantos/using-terraform-s-remote-exec-provider-with-aws-ssm-5po

set -ex
test -n "$DESTINATION_IP" || (echo missing DESTINATION_IP; exit 1)
test -n "$USERNAME"    || (echo missing USERNAME; exit 1)
test -n "$RANDOM_PORT" || (echo missing RANDOM_PORT; exit 1)
test -n "$TARGET"      || (echo missing TARGET; exit 1)
test -n "$SOCKET_FILE"      || (echo missing SOCKET_FILE; exit 1)

set +e

cleanup() {
    cat log.txt
    rm -rf log.txt
    exit $!
}

for try in {0..5}; do
    echo "Trying to port forward retry #$try"
    # The following command MUST NOT print to the stdio otherwise it will just
    # inherit the pipe from the parent process and will hold terraform's lock
    ssh -o StrictHostKeyChecking=no \
        -N -f -M -S "${SOCKET_FILE}" \
        "$USERNAME@$DESTINATION_IP" \
        -L "$(ipconfig getifaddr en0):$RANDOM_PORT:$TARGET" \
        &> log.txt  # This is the special ingredient!
    success="$?"
    if [ "$success" -eq 0 ]; then
        cleanup 0
    fi
    sleep 5s
done

echo "Failed to start a port forwarding session"
cleanup 1
