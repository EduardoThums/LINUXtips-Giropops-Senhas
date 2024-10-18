FROM python:3.13.0-alpine3.19

WORKDIR /app
EXPOSE 5000

COPY requirements.txt .

RUN pip install --target . -r requirements.txt

COPY . .

CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0"]
