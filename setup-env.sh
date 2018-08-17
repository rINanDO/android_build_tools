#!/bin/bash


DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/repos.sh"

CURRENT_DIR="$PWD"
COUNT=0

cd ~/android/system
repo sync --force-sync
. build/envsetup.sh
cd $CURRENT_DIR

#Register repositories
while [ "x${PROJECTS[COUNT]}" != "x" ]
do
	CURRENT="${PROJECTS[COUNT]}"
	FOLDER=`echo "$CURRENT" | awk '{print $1}'`
	REPOSITORY=`echo "$CURRENT" | awk '{print $2}'`
        SOURCE_REPONAME=`echo "$CURRENT" | awk '{print $3}'`
        SOURCE_BRANCH=`echo "$CURRENT" | awk '{print $4}'`
	TARGET_REPONAME=`echo "$CURRENT" | awk '{print $5}'`
        TARGET_BRANCH=`echo "$CURRENT" | awk '{print $6}'`
        ACTION=`echo "$CURRENT" | awk '{print $7}'`
        PARAM1=`echo "$CURRENT" | awk '{print $8}'`
        PARAM2=`echo "$CURRENT" | awk '{print $9}'`

	GIT_REPO_URL=`echo "https://github.com/$TARGET_REPONAME/$REPOSITORY"`

        echo "===================================================="
        echo "Registering repository for $FOLDER"
        echo "===================================================="
        croot && mkdir -p "$FOLDER" && cd "$FOLDER" && git init
        FOUND=`git remote -v|grep "$TARGET_REPONAME"`
        if [ -z "$FOUND" ]; then
            git remote add $TARGET_REPONAME $GIT_REPO_URL
        fi
        git fetch $TARGET_REPONAME
        git checkout $TARGET_REPONAME/$TARGET_BRANCH
        echo ""
	COUNT=$(($COUNT + 1))
done

cd "$CURRENT_DIR"
