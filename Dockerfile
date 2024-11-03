# FROM python:3.13.0-alpine3.19 AS builder

# COPY requirements.txt .

# RUN pip install --user -r requirements.txt --no-cache-dir && apk add --no-cache zlib libressl-dev libcrypto3

# FROM scratch

# COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
# COPY --from=builder /usr/local/lib/libpython3.13.so.1.0 /usr/local/lib/libpython3.13.so.1.0
# COPY --from=builder /usr/local/bin/python3 /usr/local/bin/python3
# COPY --from=builder /usr/local/lib/python3.13 /usr/local/lib/python3.13
# COPY --from=builder /root/.local/ /root/.local
# COPY --from=builder /lib/libz.so.1 /lib/libz.so.1
# COPY --from=builder /lib/libssl.so.3 /lib/libssl.so.3
# COPY --from=builder /lib/libcrypto.so.3 /lib/libcrypto.so.3

# ENV PYTHONPATH=/root/.local/lib/python3.13/site-packages:$PATH

# COPY app.py tailwind.config.js .
# ADD static/ static/
# ADD templates/ templates/

# ENTRYPOINT ["/usr/local/bin/python3"]
# CMD ["-m", "flask", "run", "--host", "0.0.0.0"]

FROM python:3.12.7-slim-bookworm AS builder

RUN pip install --no-cache-dir nuitka

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
        build-essential \
        ccache \
        clang \
        libfuse-dev \
        patchelf

# RUN wget -O upx.tar.xz https://github.com/upx/upx/releases/download/v4.2.4/upx-4.2.4-amd64_linux.tar.xz
# RUN tar -xf upx.tar.xz

# RUN apt-get update && apt-get install -y patchelf

COPY app.py .

RUN python -m nuitka \
        --standalone \
        --nofollow-import-to=pytest \
        --python-flag=nosite,-O \
        --clang \
        --warn-implicit-exceptions \
        --warn-unusual-code \
        --prefer-source-code \
        app.py
