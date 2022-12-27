https://hub.docker.com/r/stefansundin/ruby/

# Multi-arch

Warning: Building this takes about 2 hours.

```
# pre-requisite:
docker buildx create --use --name multiarch --node multiarch0

# build and push:
# optional arguments: --no-cache
docker buildx build --pull -f Dockerfile.ruby -t stefansundin/ruby:3.2 --platform linux/amd64,linux/arm64,linux/arm/v7 --push .
docker buildx build --pull -f Dockerfile.ruby:jemalloc -t stefansundin/ruby:3.2-jemalloc --platform linux/amd64,linux/arm64,linux/arm/v7 --push .

# run:
docker run -it stefansundin/ruby:3.2 bash
```

# Standard build

```
docker build --pull --no-cache --squash -f Dockerfile.ruby -t stefansundin/ruby:3.2-amd64 .
docker run -it stefansundin/ruby:3.2-amd64 bash
```

jemalloc:

```
docker build --pull --no-cache --squash -f Dockerfile.ruby:jemalloc -t stefansundin/ruby:3.2-amd64-jemalloc .
docker run -it stefansundin/ruby:3.2-amd64-jemalloc bash

# validate with:
ruby -r rbconfig -e "puts RbConfig::CONFIG['MAINLIBS']"
```
