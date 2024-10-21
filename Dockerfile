FROM python:3.13.0-alpine3.19 AS builder

COPY requirements.txt .

RUN pip install --user -r requirements.txt --no-cache-dir && apk add --no-cache zlib libressl-dev libcrypto3

FROM scratch

COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=builder /usr/local/lib/libpython3.13.so.1.0 /usr/local/lib/libpython3.13.so.1.0
COPY --from=builder /usr/local/bin/python3 /usr/local/bin/python3
COPY --from=builder /usr/local/lib/python3.13 /usr/local/lib/python3.13
COPY --from=builder /root/.local/ /root/.local
COPY --from=builder /lib/libz.so.1 /lib/libz.so.1
COPY --from=builder /lib/libssl.so.3 /lib/libssl.so.3
COPY --from=builder /lib/libcrypto.so.3 /lib/libcrypto.so.3

ENV PYTHONPATH=/root/.local/lib/python3.13/site-packages:$PATH

COPY app.py tailwind.config.js .
ADD static/ static/
ADD templates/ templates/

ENTRYPOINT ["/usr/local/bin/python3"]
CMD ["-m", "flask", "run", "--host", "0.0.0.0"]
