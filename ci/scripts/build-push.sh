#!/bin/sh
# hello-go-deploy-marathon build-push.sh

echo " "

# SCRIPT ARGUMENTS build-push.sh -concourse -debug
if [ "$1" = "-concourse" ]
then
    if [ "$2" = "-debug" ]
    then
        echo "build-push.sh -concoure -debug (START)"
        echo " "
        # set -e causes the shell to exit if any subcommand or pipeline returns a non-zero status.  Needed for concourse.
        # set -x enables a mode of the shell where all executed commands are printed to the terminal.
        set -e -x
        echo " "
    else
        echo "build-push.sh -concourse (START)"
        echo " "
        # set -e causes the shell to exit if any subcommand or pipeline returns a non-zero status.  Needed for concourse.
        echo " "
        set -e
        echo " "
    fi
else
    echo "build-push.sh (START)"
    echo " "
fi

# CONCOURSE
if [ "$1" = "-concourse" ]
then
    echo "????????"
    echo "Then you can run go test in that directory."
    echo " "
    echo "At start, you should be in a /tmp/build/xxxxx directory with two folders:"
    echo "   /hello-go-deploy-marathon"
    echo "   /dist (created in task-build-push.yml task file)"
    echo " "
    echo "pwd is: $PWD"
    echo " "
    echo "List whats in the current directory."
    ls -la
    echo " "

    echo "Setup the GOPATH based on current directory."
    export GOPATH=$PWD
    echo " "

    echo "Now we must move our code from the current directory ./hello-go-deploy-marathon to" 
    echo "$GOPATH/src/github.com/JeffDeCola/hello-go-deploy-marathon"
    mkdir -p src/github.com/JeffDeCola/
    cp -R ./hello-go-deploy-marathon src/github.com/JeffDeCola/.
    echo " "

    echo "cd src/github.com/JeffDeCola/hello-go-deploy-marathon"
    cd src/github.com/JeffDeCola/hello-go-deploy-marathon
    echo " "

    echo "Check that you are set and everything is in the right place for go:"
    echo "gopath is: $GOPATH"
    echo "pwd is: $PWD"
    ls -la

else
    echo "cd up to /hello-go-deploy-marathon directory."
    echo " "
    cd ../..
fi












# Put the binary hello-go-deploy-marathon filename in /dist
go build -o dist/hello-go-deploy-marathon ./main.go

# cp the Dockerfile into /dist
cp ci/Dockerfile dist/Dockerfile

# Check
echo "List whats in the /dist directory"
ls -lat dist
echo ""

# Move what you need to $GOPATH/dist
# BECAUSE the resource type docker-image works in /dist.
cp -R "./dist" "$GOPATH/."

cd "$GOPATH"
# Check whats here
echo "List whats in top directory"
ls -lat 
echo ""

# Check whats in /dist
echo "List whats in /dist"
ls -lat dist
echo ""
