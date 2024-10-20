# LINUXtips Giropops Senhas

This project was an exercise for the PICK (Programa Intensivo em Containers e Kubernetes), with the objective of building a Dockerfile capable of running a Flask application that connects to a Redis container.

## How to run

```bash
docker container run -d -p 6379:6379 --name giropops-redis redis:alpine
export REDIS_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' giropops-redis)
docker container run -d -p 5000:5000 --env REDIS_HOST=$REDIS_HOST --name giropops-senhas eduardothums/linuxtips-giropops-senhas:1.0
```

## How to access

Open your browser and go to the URL http://localhost:5000, you will see the application running.

## Explanation

There are a lot of different ways to build the Dockerfile and to run both of the containers in a way that both of them can talk with each other, the way that I solved the problem was simply running both of the containers with the default driver network and sharing the dynamic IP of the Redis container with the application container through the use of the environment variable.