#!/bin/bash 

#Deploys a war file to Openshift JBoss EWS 

declare -r APP_ACC=557d54cf5004460d9d0001a0
declare -r HOST=jbossews-juniperus.rhcloud.com
declare -r DEPLOY_DIR=jbossews/webapps/

usage() {
    echo "Usage: $(basename $0) <path-to-war> [ <target-war-name> ]"
}

# $1 - local war file to deploy
# $2 - name of the war file on the server
main() {

    if [ $# -eq 0 ]; then
        usage
        exit 1
    fi

    local file=$1 
    local path="$APP_ACC@$HOST:$DEPLOY_DIR"

    if [ $# -eq 2 ]; then
        path=$path$2.war
    fi

    if [ ${file:(-3)} != "war" ] ; then
        echo "The file is not a war file"
        exit 1
    fi

    echo "Deploying to $APP_ACC@$HOST" 
    scp $file $path
}



main "$@"
