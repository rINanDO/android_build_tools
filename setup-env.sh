#!/bin/bash

#SETUP environment
#cd ~/android/system
#. build/envsetup.sh
#breakfast i9100

CURRENT_DIR="$PWD"

SOURCE_REPO_URL="https://www.github.com/lineageos"
CUSTOM_REPO_URL="https://www.github.com/rinando/"

SOURCE_REPO_REMOTE="github"
CUSTOM_REPO_REMOTE="rinando"

BRANCH="staging/lineage-15.1"

COUNT=0
PROJECTS=(
'art				android_art				github	rebase'
'bionic				android_bionic				github'
'build/soong			android_build_soong			github'
'build/make			android_build				github	rebase'
'frameworks/av			android_frameworks_av			github'
'frameworks/base		android_frameworks_base			github'
'frameworks/native		android_frameworks_native		github'
'frameworks/opt/telephony	android_frameworks_opt_telephony	github'
'vendor/lineage			android_vendor_lineage			github'
'hardware/interfaces		android_hardware_interfaces		github'
'hardware/libhardware		android_hardware_libhardware		github'
'hardware/lineage/interfaces	android_hardware_lineage_interfaces	github'
'hardware/samsung		android_hardware_samsung		github'
'packages/services/Telephony	android_packages_services_Telephony	github'
'system/connectivity/wificond	android_system_connectivity_wificond	github'
'system/core			android_system_core			github'
'device/samsung/galaxys2-common	android_device_samsung_galaxys2-common	github'
'device/samsung/i9100		android_device_samsung_i9100		github'
'kernel/samsung/smdk4412	android_kernel_samsung_smdk4412		github'
'libcore			android_libcore				github	rebase'
'lineage-sdk			android_lineage-sdk			github	rebase'
'device/lineage/sepolicy	android_device_lineage_sepolicy		github	rebase'
'packages/apps/Settings		android_packages_apps_Settings		github	rebase'
'packages/apps/LineageParts	android_packages_apps_LineageParts	github	rebase'
)

#Register all custom repositories
echo Registering repo''s from "$CUSTOM_REPO_REMOTE" ...
while [ "x${PROJECTS[COUNT]}" != "x" ]
do
	CURRENT="${PROJECTS[COUNT]}"
	FOLDER=`echo "$CURRENT" | awk '{print $1}'`
	REPOSITORY=`echo "$CURRENT" | awk '{print $2}'`
	GIT_REPO_URL=`echo "$CUSTOM_REPO_URL$REPOSITORY"`

        echo "Registering repository for $FOLDER"
        croot && cd "$FOLDER"
        FOUND=`git remote -v|grep "$CUSTOM_REPO_REMOTE"`
        if [[ $FOUND ]]; then
            git remote remove $CUSTOM_REPO_REMOTE
        fi
        git remote add $CUSTOM_REPO_REMOTE $GIT_REPO_URL
        git config credential.helper store
	COUNT=$(($COUNT + 1))
done



#Fetch and checkout custom repositories
COUNT=0
echo Fetching and checking out repo''s of "$CUSTOM_REPO_REMOTE" ...
while [ "x${PROJECTS[COUNT]}" != "x" ]
do
	CURRENT="${PROJECTS[COUNT]}"
	FOLDER=`echo "$CURRENT" | awk '{print $1}'`
	REPOSITORY=`echo "$CURRENT" | awk '{print $2}'`
	GIT_REPO_URL=`echo "$CUSTOM_REPO_URL$REPOSITORY"`

        echo "$GIT_REPO_URL"
        croot && cd "$FOLDER"
        git fetch $CUSTOM_REPO_REMOTE
        git checkout $CUSTOM_REPO_REMOTE/$BRANCH
	COUNT=$(($COUNT + 1))
done

cd "$CURRENT_DIR"
