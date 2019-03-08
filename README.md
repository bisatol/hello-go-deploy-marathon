# hello-go-deploy-marathon

[![Go Report Card](https://goreportcard.com/badge/github.com/JeffDeCola/hello-go-deploy-marathon)](https://goreportcard.com/report/github.com/JeffDeCola/hello-go-deploy-marathon)
[![GoDoc](https://godoc.org/github.com/JeffDeCola/hello-go-deploy-marathon?status.svg)](https://godoc.org/github.com/JeffDeCola/hello-go-deploy-marathon)
[![Maintainability](https://api.codeclimate.com/v1/badges/24c711ac3a1ec5155969/maintainability)](https://codeclimate.com/github/JeffDeCola/hello-go-deploy-marathon/maintainability)
[![Issue Count](https://codeclimate.com/github/JeffDeCola/hello-go-deploy-marathon/badges/issue_count.svg)](https://codeclimate.com/github/JeffDeCola/hello-go-deploy-marathon/issues)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://jeffdecola.mit-license.org)

`hello-go-deploy-marathon` _uses Concourse CI to test, build, push (to DockerHub)
and deploy a long running "hello-world" Docker Image to Mesos/Marathon._

[hello-go-deploy-marathon Docker Image](https://hub.docker.com/r/jeffdecola/hello-go-deploy-marathon)
 on DockerHub.

[hello-go-deploy-marathon GitHub Webpage](https://jeffdecola.github.io/hello-go-deploy-marathon/).

## PREREQUISITES

I used go as my language.  Feel free to use another one,

* [go](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/development/languages/go-cheat-sheet)

To build a docker image you will need docker on your machine,

* [docker](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/orchestration/builds-deployment-containers/docker-cheat-sheet)

To push a docker image you will need,

* [DockerHub account](https://hub.docker.com/)

To deploy to mesos/marathon you will need,

* [marathon](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/orchestration/cluster-managers-resource-management-scheduling/marathon-cheat-sheet)
* [mesos](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/orchestration/cluster-managers-resource-management-scheduling/mesos-cheat-sheet)

As a bonus, you can use Concourse CI to run the scripts,

* [concourse](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/operations-tools/continuous-integration-continuous-deployment/concourse-cheat-sheet)

## RUN

To run from the command line,

```bash
go run main.go
```

Every 2 seconds `hello-go-deploy-marathon` will print:

```bash
Hello everyone, count is: 1
Hello everyone, count is: 2
Hello everyone, count is: 3
etc...
```

## STEP 1 - TEST

Lets unit test the code,

```go
go test -cover ./... | tee /test/test_coverage.txt
```

This is the test script `/ci/scripts/unit-tests.sh` used by concourse.

## STEP 2 - BUILD

Lets build a docker image from your binary /bin/hello-go.

First, create a binary `hello-go`,
I keep them in /bin and use .gitignore for this directory.

```bash
go build -o bin/hello-go main.go
```

Build your docker image from binary /bin/hello-go
using /build-push/Dockerfile,

```bash
cd build-push
docker build -t jeffdecola/hello-go-deploy-marathon .
```

Obviously, replace `jeffdecola` with your DockerHub username.

Check your docker images on your machine,

```bash
docker images
```

It will be listed as `jeffdecola/hello-go`

This is the build script `/ci/scripts/build-push.sh` used by concourse.

## STEP 3 - PUSH

Lets push your built docker image to DockerHub.

```go
```

This is the push script `/ci/scripts/build-push.sh` used by concourse.

## STEP 4 - DEPLOY

Lets pull the image from DockerHub to deploy to mesos/marathon.

```go
```

This is the deploy script `/ci/scripts/deploy.sh` used by concourse.












## BUILD - PUSH DOCKER IMAGE TO DOCKER HUB

Push to your newly built docker image to DockerHub.

```bash
docker login
docker push jeffdecola/hello-go
```

Check you image at DockerHub. My image is
[https://hub.docker.com/r/jeffdecola/hello-go](https://hub.docker.com/r/jeffdecola/hello-go).

Once image is is on DockerHub, you can run in interactive mode (-i)
so you can `ctrl-c` to stop.

Erase your local image first to prove it grabs it from dockerhub,

```bash
docker rmi jeffdecola/hello-go
```

Now run it. Docker will grab the image from dockerHub
and start a docker container on your machine.

```bash
docker run -t -i jeffdecola/hello-go
```

## DEPLOY - APP TO MARATHON

The marathon .json file,

[_`resource-marathon-deploy`_](https://github.com/JeffDeCola/resource-marathon-deploy)
uses a Marathon .json file (app.json) to deploys the newly created docker image
(APP) to Marathon.

The `hello-go` docker image can now be manually deployed from
DockerHub to mesos/marathon by using the command:

```bash
curl -X PUT http://10.141.141.10:8080/v2/apps/hello-go-long-running \
-d @app.json \
-H "Content-type: application/json"
```

The `app.json` file will pick the latest image a DockerHub
`jeffdecola/hello-go:latest`.

## TESTED, BUILT & PUSHED TO DOCKERHUB USING CONCOURSE

To automate the creation of the `hello-go` docker image, a concourse pipeline
will,

* Update README.md for hello-go github webpage.
* Unit Test the code.
* Build the docker image `hello-go` and push to DockerHub.
* Deploy the DockerHub image to mesos/marathon.

![IMAGE - hello-go concourse ci pipeline - IMAGE](docs/pics/hello-go-pipeline.jpg)

As seen in the pipeline diagram, the _resource-dump-to-dockerhub_ uses
the resource type
[docker-image](https://github.com/concourse/docker-image-resource)
to push a docker image to dockerhub.

[_`resource-marathon-deploy`_](https://github.com/JeffDeCola/resource-marathon-deploy)
deploys the newly created docker image to marathon.

`hello-go` also contains a few extra concourse resources:

* A resource (_resource-slack-alert_) uses a [docker image](https://hub.docker.com/r/cfcommunity/slack-notification-resource)
  that will notify slack on your progress.
* A resource (_resource-repo-status_) use a [docker image](https://hub.docker.com/r/dpb587/github-status-resource)
  that will update your git status for that particular commit.
* A resource ([_`resource-template`_](https://github.com/JeffDeCola/resource-template))
  that can be used as a starting point and template for creating other concourse
  ci resources.

For more information on using concourse for continuous integration,
refer to my cheat sheet on [concourse](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/continuous-integration-continuous-deployment/concourse-cheat-sheet).
