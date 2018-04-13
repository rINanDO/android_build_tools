#!/bin/bash

#SETUP environment
cd ~/android/system

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


CURRENT_DIR="$PWD"

SOURCE_REPO_URL="https://www.github.com/lineageos"
CUSTOM_REPO_URL="https://www.github.com/rinando/"

SOURCE_REPO_REMOTE="github"
CUSTOM_REPO_REMOTE="rinando"

BRANCH="lineage-15.1"

COUNT=0
PROJECTS=(
'bionic				android_bionic				github	rebase'
'build/make			android_build				github	rebase'
'build/soong			android_build_soong			github	rebase'
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
'libcore			android_libcore				github	rebase'
'lineage-sdk			android_lineage-sdk			github	rebase'
'device/lineage/sepolicy	android_device_lineage_sepolicy		github	rebase'
'packages/apps/Settings		android_packages_apps_Settings		github	rebase'
'packages/apps/LineageParts	android_packages_apps_LineageParts	github	rebase'
'vendor/samsung			proprietary_vendor_samsung		github	rebase'
)

echo Cleaning untracked files...
repo forall -vc "git clean -f"

#Register all custom repositories
echo Rebasing repo''s from  $SOURCE_REPO_REMOTE to $CUSTOM_REPO_REMOTE ...
while [ "x${PROJECTS[COUNT]}" != "x" ]
do
	CURRENT="${PROJECTS[COUNT]}"
	FOLDER=`echo "$CURRENT" | awk '{print $1}'`
	REPOSITORY=`echo "$CURRENT" | awk '{print $2}'`
        SOURCE_REPO_REMOTE=`echo "$CURRENT" | awk '{print $3}'`
        REBASE_ACTION=`echo "$CURRENT" | awk '{print $4}'`
	GIT_REPO_URL=`echo "$CUSTOM_REPO_URL$REPOSITORY"`

        echo "======= Rebasing repository for '$FOLDER' =========="
        croot && cd "$FOLDER"
        git fetch $SOURCE_REPO_REMOTE
        git checkout $CUSTOM_REPO_REMOTE/$BRANCH
        case $REBASE_ACTION in
         rebase )
		git rebase $SOURCE_REPO_REMOTE/$BRANCH
		echo -n "OK to push to repo (y/N)? "
		read USERINPUT
		case $USERINPUT in
		 y|Y)
		    echo "Pushing to $CUSTOM_REPO_REMOTE"
		    	git push $CUSTOM_REPO_REMOTE HEAD:$BRANCH --force
		    ;;
		 *) ;;
		esac
		;;
	esac
        echo "========================================================================"
	COUNT=$(($COUNT + 1))
done

cd "$CURRENT_DIR"
