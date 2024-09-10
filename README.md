https://hub.docker.com/r/stefansundin/ruby/

# Usage

Opt in to Ruby YJIT by setting an environment variable:

```
RUBYOPT="--yjit"
```

Validate with:

```shell
$ docker run --pull always -e RUBYOPT="--yjit" -it stefansundin/ruby:3.3 ruby -e "puts RUBY_DESCRIPTION"
ruby 3.3.5 (2024-09-03 revision ef084cc8f4) +YJIT [aarch64-linux]
```

# Multi-arch build

Warning: Building this can take several hours depending on your hardware.

```shell
# pre-requisite:
docker buildx create --use --name multiarch --node multiarch0

# build and push:
# optional arguments: --no-cache
docker buildx build --progress plain --pull --push -f Dockerfile.ruby -t stefansundin/ruby:3.3 --platform linux/amd64,linux/arm64,linux/arm/v7 .
docker buildx build --progress plain --pull --push -f Dockerfile.ruby:jemalloc -t stefansundin/ruby:3.3-jemalloc --platform linux/amd64,linux/arm64,linux/arm/v7 .

# run:
docker run -it stefansundin/ruby:3.3 bash
```

# Standard build

```shell
docker build --progress plain --pull --no-cache -f Dockerfile.ruby -t stefansundin/ruby:3.3-test .
docker run -it stefansundin/ruby:3.3-test bash
```

jemalloc:

```shell
docker build --pull --no-cache --squash -f Dockerfile.ruby:jemalloc -t stefansundin/ruby:3.3-test-jemalloc .
docker run -it stefansundin/ruby:3.3-test-jemalloc bash

# validate with:
ruby -r rbconfig -e "puts RbConfig::CONFIG['MAINLIBS']"
```
