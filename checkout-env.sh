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
'bionic				android_bionic				github	rebase'
'build/make			android_build				github	rebase'
'build/soong			android_build_soong			github	rebase'
'external/stlport		android_external_stlport		github	rebase'
'frameworks/av			android_frameworks_av			github	rebase'
'frameworks/base		android_frameworks_base			github	rebase'
'frameworks/native		android_frameworks_native		github	rebase'
'frameworks/opt/telephony	android_frameworks_opt_telephony	github	rebase'
'vendor/lineage			android_vendor_lineage			github	rebase'
'hardware/interfaces		android_hardware_interfaces		github	rebase'
'hardware/libhardware		android_hardware_libhardware		github	rebase'
'hardware/lineage/interfaces	android_hardware_lineage_interfaces	github	rebase'
'hardware/samsung		android_hardware_samsung		github	rebase'
'packages/services/Telephony	android_packages_services_Telephony	github	rebase'
'system/connectivity/wificond	android_system_connectivity_wificond	aosp	norebase'
'system/core			android_system_core			github	rebase'
'device/samsung/galaxys2-common	android_device_samsung_galaxys2-common	github	norebase'
'device/samsung/i9100		android_device_samsung_i9100		github	norebase'
'kernel/samsung/smdk4412	android_kernel_samsung_smdk4412		github	norebase'
)

#Register all custom repositories
echo Checkingout repo''s from  $SOURCE_REPO_REMOTE to $CUSTOM_REPO_REMOTE ...
while [ "x${PROJECTS[COUNT]}" != "x" ]
do
	CURRENT="${PROJECTS[COUNT]}"
	FOLDER=`echo "$CURRENT" | awk '{print $1}'`
	REPOSITORY=`echo "$CURRENT" | awk '{print $2}'`
        SOURCE_REPO_REMOTE=`echo "$CURRENT" | awk '{print $3}'`
        REBASE_ACTION=`echo "$CURRENT" | awk '{print $4}'`
	GIT_REPO_URL=`echo "$CUSTOM_REPO_URL$REPOSITORY"`

        echo "======= Checkout repository for '$FOLDER'"
        croot && cd "$FOLDER"
        git fetch $SOURCE_REPO_REMOTE
        git checkout $CUSTOM_REPO_REMOTE/$BRANCH        
        echo
	COUNT=$(($COUNT + 1))
done

cd "$CURRENT_DIR"
