#!/bin/bash

cd ~/android/system
. build/envsetup.sh

CURRENT_DIR="$PWD"

SOURCE_REPO_URL="https://www.github.com/lineageos"
CUSTOM_REPO_URL="https://www.github.com/rinando/"


BRANCH="lineage-16.0"

COUNT=0
PROJECTS=(
'hardware/samsung		android_hardware_samsung		github	lineage-16.0 	rinando	lineage-16.0	rebase'
'hardware/ril			android_hardware_ril			github	lineage-16.0 	rinando	lineage-16.0	rebase'
'bionic				android_bionic				github	lineage-16.0 	rinando	lineage-16.0	rebase'
'build/make			android_build				github	lineage-16.0 	rinando	lineage-16.0	rebase'
'build/soong			android_build_soong			github	lineage-16.0 	rinando	lineage-16.0	rebase'
'frameworks/av			android_frameworks_av			github	lineage-16.0 	rinando	lineage-16.0	rebase'
'frameworks/base		android_frameworks_base			github	lineage-16.0 	rinando	lineage-16.0	rebase'
'frameworks/native		android_frameworks_native		github	lineage-16.0 	rinando	lineage-16.0	rebase'
'vendor/lineage			android_vendor_lineage			github	lineage-16.0 	rinando	lineage-16.0	rebase'

#'hardware/lineage/interfaces	android_hardware_lineage_interfaces	github	rebase'
#'packages/services/Telephony	android_packages_services_Telephony	github	rebase'
#'libcore			android_libcore				github	rebase'
#'lineage-sdk			android_lineage-sdk			github	rebase'
#'device/lineage/sepolicy	android_device_lineage_sepolicy		github	rebase'
#'packages/apps/Settings		android_packages_apps_Settings		github	rebase'
#'packages/apps/LineageParts	android_packages_apps_LineageParts	github	rebase'
#'vendor/samsung			proprietary_vendor_samsung		github	rebase'
)

# Sync repo
cd ~/android/system

echo Stashing your work...
while [ "x${PROJECTS[COUNT]}" != "x" ]
do
	CURRENT="${PROJECTS[COUNT]}"
	FOLDER=`echo "$CURRENT" | awk '{print $1}'`

        echo "======= Stashing repository '$FOLDER' =========="
        croot && cd "$FOLDER"
        git stash
        echo "========================================================================"
	COUNT=$(($COUNT + 1))
done

COUNT=0
echo -n "OK to sync repo (y/N)? "
read USERINPUT
case $USERINPUT in
 y|Y)
	echo "Synching..."
        repo sync
        . build/envsetup.sh
        breakfast i9100
 ;;
 *) ;;
esac



echo Cleaning untracked files...
repo forall -vc "git clean -f"

#Register all custom repositories
echo Rebasing repo''s from  $SOURCE_REPO_REMOTE to $CUSTOM_REPO_REMOTE ...
while [ "x${PROJECTS[COUNT]}" != "x" ]
do
	CURRENT="${PROJECTS[COUNT]}"
	FOLDER=`echo "$CURRENT" | awk '{print $1}'`
	REPOSITORY=`echo "$CURRENT" | awk '{print $2}'`
        SOURCE_REPO=`echo "$CURRENT" | awk '{print $3}'`
        SOURCE_BRANCH=`echo "$CURRENT" | awk '{print $4}'`
	TARGET_REPO=`echo "$CURRENT" | awk '{print $5}'`
        TARGET_BRANCH=`echo "$CURRENT" | awk '{print $6}'`
        ACTION=`echo "$CURRENT" | awk '{print $7}'`
        PARAM1=`echo "$CURRENT" | awk '{print $8}'`
        PARAM2=`echo "$CURRENT" | awk '{print $9}'`
	GIT_REPO_URL=`echo "$CUSTOM_REPO_URL$REPOSITORY"`

        echo "======= Rebasing repository for '$FOLDER' =========="
        croot && cd "$FOLDER"
        git fetch $SOURCE_REPO
        git checkout $TARGET_REPO/$TARGET_BRANCH
        case $ACTION in
         rebase )
		git rebase $SOURCE_REPO/$SOURCE_BRANCH
                git stash apply
		echo -n "OK to push to repo (y/N)? "
		read USERINPUT
		case $USERINPUT in
		 y|Y)
		    echo "Pushing to $TARGET_REPO"
		    	git push $TARGET_REPO HEAD:$TARGET_BRANCH --force
		    ;;
		 *) ;;
		esac
		;;
	 cherrypick )
                git cherry-pick $PARAM1
		git cherry-pick $PARAM2
		;;
	esac
        echo "========================================================================"
	COUNT=$(($COUNT + 1))
done

cd "$CURRENT_DIR"

# Manual cherry-pick because:
#remote: error: GH001: Large files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.
#remote: error: Trace: eb932947e5ac9edae12304de13e90389
#remote: error: See http://git.io/iEPt8g for more information.
#remote: error: File libunwindstack/tests/files/offline/jit_debug_x86_32/libartd.so is 219.06 MB; this exceeds GitHub's file size limit of 100.00 MB
croot && cd system/core
git checkout tags/android-9.0.0_r1
git cherry-pick 58fddf698a0d615142dea50b801f335dbe1a69cc
git cherry-pick 6e0483c72e4a8abbcc7c49f5352d4dfac891f158

croot && breakfast i9100

