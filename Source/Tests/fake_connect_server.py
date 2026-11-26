#!/usr/bin/env python3
"""Minimal UDP server used by the connect-userinfo sanitizer regression test.

It answers getchallenge so the client proceeds to CL_CheckForResend(), where
an oversized userinfo string historically overran a 1024-byte stack buffer.
"""

import socket
import sys
import time


def main():
    port = int(sys.argv[1])
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind(("127.0.0.1", port))
    sock.settimeout(20)
    deadline = time.time() + 20

    while time.time() < deadline:
        try:
            data, addr = sock.recvfrom(65535)
        except socket.timeout:
            break

        text = data[4:].decode("latin1", "replace") if data[:4] == b"\xff\xff\xff\xff" else data.decode("latin1", "replace")
        if text.startswith("getchallenge"):
            sock.sendto(b"\xff\xff\xff\xffchallengeResponse 12345 42\n", addr)
        if text.startswith("connect "):
            print("SAW_CONNECT", flush=True)
            break

    sock.close()


if __name__ == "__main__":
    main()
