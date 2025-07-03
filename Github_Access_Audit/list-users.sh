#!/bin/bash

###################
# About: This script is used to fetch all the users who can access a repo in Gituhub along with their roles
# Input: Two arguments specifying the repo owner and repository name
###################


USER_NAME=$username
TOKEN=$token

REPO_OWNER=$1
REPO_NAME=$2

no_of_cmd_args=2

# Function to check command line arguments
function helper {
    if [ $# -ne $no_of_cmd_args ]; then
        echo "Command Line Arguments missing"
        echo "Execute the script with repo owner and repo name details as arguments"
        exit 1
    fi
}


github_api="https://api.github.com"

#Function to send request to the GitHub API 
function get_github_api {

        local endpoint="$1"
        local url="${github_api}/${endpoint}"

        #Send a GET request to the GitHub API
        curl -s -u "${USER_NAME}:${TOKEN}" "$url"
}

#Function to list the users to have access to the repository
function get_list_of_users {
        #enpoint to get the list of collaborators
        local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

        #Fetch the list of collaborators on the repo
        local collaborators=$(get_github_api "$endpoint")

        #Check for collaborators
        if [[ -z "$collaborators" ]]; then
                echo "No collaborators found for this ${REPO_OWNER}/${REPO_NAME} repository"

        else
                echo "Collabrators for  ${REPO_OWNER}/${REPO_NAME} repository are..\n"
                echo "| Username | Role |"
                echo "| -------- | ---- |"

                while IFS= read -r user; do
                        local username=$(echo "$user" | jq -r '.login')
                        local role=$(echo "$user" |jq -r '.permissions | keys | .[]')
                        echo "| $username | $role |"
                done < <(echo "$collaborators" | jq -c '.[]')
        fi

}

helper "$@"

#Calling the function to get the collaborators
get_list_of_users
                                                                                                                                                       65,0-1        Bot
