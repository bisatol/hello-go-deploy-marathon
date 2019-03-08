#!/bin/sh
# hello-go-deploy-marathon unit-test.sh

echo " "

# SCRIPT ARGUMENTS unit-test.sh -concourse -debug
if [ "$1" = "-concourse" ]
then
    if [ "$2" = "-debug" ]
    then
        echo "unit-test.sh -concoure -debug (START)"
        echo " "
        # set -e causes the shell to exit if any subcommand or pipeline returns a non-zero status.  Needed for concourse.
        # set -x enables a mode of the shell where all executed commands are printed to the terminal.
        set -e -x
        echo " "
    else
        echo "unit-test.sh -concourse (START)"
        echo " "
        # set -e causes the shell to exit if any subcommand or pipeline returns a non-zero status.  Needed for concourse.
        echo " "
        set -e
        echo " "
    fi
else
    echo "unit-test.sh (START)"
    echo " "
fi

# CONCOURSE
if [ "$1" = "-concourse" ]
then
    echo "The goal is to set up a go src/github.com/JeffDeCola/hello-go-deploy-marathon directory."
    echo "Then you can run go test in that directory."
    echo " "

    echo "At start, you should be in a /tmp/build/xxxxx directory with two folders:"
    echo "   /hello-go-deploy-marathon"
    echo "   /coverage-results (created in task-unit-test.yml task file)"
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
    echo " "

else
    echo "cd up to /hello-go-deploy-marathon directory."
    cd ../..
    echo " "
fi

echo "Run go test -cover"
echo "   -cover shows the percentage coverage."
echo "   Put results in test_coverage.txt file"
go test -cover ./... | tee test_coverage.txt
echo " "

echo "Clean test_coverage.txt file - add some whitespace to the begining of each line."
sed -i -e 's/^/     /' test_coverage.txt
echo " "

# CONCOURSE
if [ "$1" = "-concourse" ]
then
    echo "The test_coverage.txt file will be used by the concourse pipeline to send to slack."
    echo " "

    echo "Move text_coverage.txt to /coverage-results directory."
    mv "test_coverage.txt" "$GOPATH/coverage-results/."
    echo " "
fi

echo "unit-test.sh - END"
echo " "
