FROM python:3.13.0-alpine3.19 AS builder

COPY requirements.txt .
RUN pip install --no-cache-dir --target venv -r requirements.txt

FROM cgr.dev/chainguard/python:latest-dev

WORKDIR /app
EXPOSE 5000
ENV PYTHONPATH="/app/venv"

COPY --from=builder /app/venv venv
COPY . .

CMD ["-m", "flask", "run", "--host=0.0.0.0"]
