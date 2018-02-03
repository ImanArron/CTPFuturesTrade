#!/bin/sh
PROJECTS="FuturesTrade"
RESOURCE="FuturesTradeBundle"
VERSIONS=("1.0" "1.0")
CONFIGURATION="Release"

BUILD_DIR="build"

function lipoFramework() {
    rm -r -f $1.framework

    cp -r "${BUILD_DIR}/${CONFIGURATION}-iphoneos/$1.framework" .

    # lipo -create -output "$1.framework/$1" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/$1.framework/$1" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/$1.framework/$1"
    lipo -create -output "$1.framework/$1" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/$1.framework/$1"
}

function cleanBuild() {
    rm -r -f ${BUILD_DIR}
}

projectsCount=${#PROJECTS[@]}
buildDate=`date +'%m%d'`

for ((i=0;i<$projectsCount;++i))
do
    project=${PROJECTS[$i]}
    version=${VERSIONS[$i]}

    BUILD_FLAGS="-target ${project} -configuration ${CONFIGURATION} BUILD_DIR=${BUILD_DIR} clean build"

    xcodebuild -sdk iphoneos ${BUILD_FLAGS}
    # xcodebuild -sdk iphonesimulator ${BUILD_FLAGS}

    echo "Project is: "
    echo ${project}
    lipoFramework "${project}"

    # /usr/libexec/PlistBuddy -c "Set CFBundleShortVersionString $version.$buildDate" $project.framework/Info.plist
    # /usr/libexec/PlistBuddy -c "Set CFBundleVersion $version" $project.framework/Info.plist

    cleanBuild

done

#build resource bundle
rm -r -f ${RESOURCE}.bundle
BUILD_FLAGS="-target ${RESOURCE} -configuration ${CONFIGURATION} BUILD_DIR=${BUILD_DIR} clean build"
xcodebuild -sdk iphoneos ${BUILD_FLAGS}
cp -r "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${RESOURCE}.bundle" .

rm -r -f ${BUILD_DIR}
