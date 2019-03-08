#!/bin/sh
# hello-go-deploy-marathon readme-github-pages.sh

echo " "

# SCRIPT ARGUMENTS readme-github-pages.sh -concourse -debug
if [ "$1" = "-concourse" ]
then
    if [ "$2" = "-debug" ]
    then
        echo "readme-github-pages.sh -concoure -debug (START)"
        echo " "
        # set -e causes the shell to exit if any subcommand or pipeline returns a non-zero status. Needed for concourse.
        # set -x enables a mode of the shell where all executed commands are printed to the terminal.
        set -e -x
        echo " "
    else
        echo "readme-github-pages.sh -concourse (START)"
        echo " "
        # set -e causes the shell to exit if any subcommand or pipeline returns a non-zero status.  Needed for concourse.
        echo " "
        set -e
        echo " "
    fi
else
    echo "readme-github-pages.sh (START)"
    echo " "
fi

# CONCOURSE
if [ "$1" = "-concourse" ]
then
    echo "The goal is to git clone /hello-go-deploy-marathon to /hello-go-deploy-marathon-updated"
    echo "Then you can edit the /docs/_includes/README.md for GITHUB WEBPAGES in that directory"
    echo " "

    echo "At start, you should be in a /tmp/build/xxxxx directory with two folders:"
    echo "   /hello-go-deploy-marathon"
    echo "   /hello-go-deploy-marathon-updated (created in task-build-push.yml task file)"
    echo " "

    echo "pwd is: $PWD"
    echo " "

    echo "List whats in the current directory"
    ls -la
    echo " "

    echo "git clone hello-go-deploy-marathon to hello-go-deploy-marathon-updated"
    git clone hello-go-deploy-marathon hello-go-deploy-marathon-updated
    echo " "

    echo "cd hello-go-deploy-marathon-updated"
    cd hello-go-deploy-marathon-updated
    echo " "

    echo "List whats in the current directory"
    ls -la
    echo " "

else
    echo "cd up to /hello-go-deploy-marathon directory"
    echo " "
    cd ../..
fi

echo "FOR GITHUB WEBPAGES"
echo "THE GOAL IS TO COPY README.md to /docs/_includes/README.md"
echo " "

echo "Remove everything before the second heading in README.md.  Place in temp-README.md"
sed '0,/GitHub Webpage/d' README.md > temp-README.md
# Change the first heading ## to #
sed -i '0,/##/{s/##/#/}' temp-README.md
# update the image links (remove docs/)
sed -i 's#IMAGE](docs/#IMAGE](#g' temp-README.md
echo " "

commit="yes"

echo "Does docs/_includes/README.md exist?"
if test -f docs/_includes/README.md
then
    echo "    Yes, it exists."
    # CHECK IF THERE IS A DIFF
    if (cmp -s temp-README.md docs/_includes/README.md)
    then
        commit="no"
        echo "    No Changes are needed, Do not need to git commit and push"
    else
        echo "    Updates are needed."
    fi
    echo " "
else
    echo "    No, it does not exist."
    echo "    Creating the _includes directory"
    mkdir docs/_includes
    echo " "
fi

if [ "$commit" = "yes" ]
then
    echo "cp updated temp-README.md to docs/_includes/README.md"
    cp temp-README.md docs/_includes/README.md
    echo " "

    echo "remove temp-README.md"
    rm temp-README.md
    echo " "
    
    if [ "$1" = "-concourse" ]
    then
        echo "update some global git variables"
        git config --global user.email "jeff@keeperlabs.com"
        git config --global user.name "Jeff DeCola (Concourse)"
        echo " "
        git config --list
        echo " "
    fi

    echo "ONLY git add and commit what is needed to protect from unforseen issues"
    echo "git add"
    git add docs/_includes/README.md
    echo "git commit"
    git commit -m "Update docs/_includes/README.md for GitHub Page"
    echo " "

    echo "git status"
    git status
    echo " "

    if [ "$1" = "-concourse" ]
    then
        echo "git push not needed in concourse since its done in pipeline"
        echo " "
    else
        echo "git push"
        git push
        echo " "
    fi

else
    echo "remove temp-README.md"
    rm temp-README.md
    echo " "
fi

echo "readme-github-pages.sh (END)"
echo " "
