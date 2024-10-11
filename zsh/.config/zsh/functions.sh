#!/usr/bin/env bash

function create_repo {
    # Check if a repository name is provided
    if [ -z "$1" ]; then
        echo "Error: Repository name is required."
        return 1
    fi

    # Check if the current directory is a Git repository
    if [ ! -d ".git" ]; then
        git init
    fi

    # Try to create the repository with GitHub CLI
    gh repo create "$1" --public --source=. --remote=origin
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create the repository on GitHub."
        return 1
    fi

    echo "Repository '$1' created successfully and linked to the current directory."
}
