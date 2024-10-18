```bash
docker container run -d -p 6379:6379 --name giropops-redis redis:alpine
export REDIS_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' giropops-redis)
docker container run -d -p 5000:5000 --env REDIS_HOST=$REDIS_HOST --name giropops-senhas eduardothums/linuxtips-giropops-senhas:1.0
```
