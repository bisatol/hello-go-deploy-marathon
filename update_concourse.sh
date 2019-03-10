#!/bin/bash
# hello-go-deploy-marathon update_concourse.sh

fly -t ci set-pipeline -p hello-go-deploy-marathon -c ci/pipeline.yml --load-vars-from ../../../../.credentials.yml
