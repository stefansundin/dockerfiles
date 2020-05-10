# Multi-arch

Warning: Building this takes about 2 hours.

```
# pre-requisite:
docker buildx create --use --name multiarch

# build and push:
# optional arguments: --pull --no-cache
docker buildx build -f Dockerfile.ruby -t stefansundin/ruby:2.7-multiarch --platform linux/amd64,linux/arm64,linux/arm/v7 --push .

# run:
docker run -it stefansundin/ruby:2.7-multiarch bash
```
