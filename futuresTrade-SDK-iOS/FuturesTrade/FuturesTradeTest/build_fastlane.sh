# 需要根据不同的工程进行配置的变量
PlistPath="/FuturesTradeTest/Info.plist"
BundleId="com.upchina.qhydt"
AppName="期货交易"

BUILD_TYPE="adhoc"
for args in $@
    do
        BUILD_TYPE=${args}
    break
done
echo "BUILD_TYPE is:"
echo ${BUILD_TYPE}

if [ ${BUILD_TYPE} == "inhouse" ]
then
    BundleId="com.jiujiujin.futurestrade"
fi

# project name and path
project_path="."
project_name=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')
echo "project_path is:"
echo ${project_path}
echo "project_name is:"
echo ${project_name}

setBuildNumber() {
    tempShortVersion=$1
    echo "tempShortVersion is:"
    echo ${tempShortVersion}
    tempBuildNumber=$2
    echo "tempBuildNumber is:"
    echo ${tempBuildNumber}
    svLen=${#tempShortVersion}
    echo "svLen is:"
    echo ${svLen}
    bnLen=${#tempBuildNumber}
    echo "bnLen is:"
    echo ${bnLen}
    if [ ${svLen} == ${bnLen} ]
    then
        tempNumber="0"
        return ${tempNumber}
    else
        location=`expr ${bnLen} - 1`
        echo "location is:"
        echo ${location}
        lastNum=${tempBuildNumber:${location}:1}
        echo "lastNum is:"
        echo ${lastNum}
        lastNum=`expr ${lastNum} + 1`
        return ${lastNum}
    fi
}

app_infoplist_path=${project_path}${PlistPath}
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${app_infoplist_path}")
echo "bundleShortVersion is:"
echo ${bundleShortVersion}
buildNumber=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${app_infoplist_path}")
echo "buildNumber before set is:"
echo ${buildNumber}
setBuildNumber ${bundleShortVersion} ${buildNumber}
buildNumber=$?
buildNumber=${bundleShortVersion}.${buildNumber}
echo "buildNumber after set is:"
echo ${buildNumber}
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${app_infoplist_path}"

rm -rf out

export PATH="$HOME/.fastlane/bin:$PATH"
fastlane build build_number:${buildNumber} type:${BUILD_TYPE} project_name:${project_name} build_address:"local"

uploadToFir() {
    ipa_name="out/iOS-${project_name}-${buildNumber}.ipa"
    # 公司fir账号
    API_TOKEN="d5516898ead92985028f64e6f3e5a9ce"
    echo ${ipa_name}
    INFO=`curl  -X "POST" "http://api.fir.im/apps" -H "Content-Type: application/json" -d "{\"type\":\"ios\", \"bundle_id\":\"${BundleId}\", \"api_token\":\"${API_TOKEN}\"}"`
    KEY=$(echo ${INFO} | grep "binary.*url" -o | grep "key.*$" -o | awk -F '"' '{print $3;}')
    TOKEN=$(echo ${INFO} | grep "binary.*url" -o | grep "token.*$" -o | awk -F '"' '{print $3;}')
    bundleVersion=${buildNumber}
    curl -F "file=@${ipa_name}" -F "key=${KEY}" -F "token=${TOKEN}"  -F "x:release_type=Adhoc"  -F "x:name=${AppName}" -F "x:version=${bundleShortVersion}" -F "x:build=${bundleVersion}" https://up.qbox.me
}

if [ ${BUILD_TYPE} == "adhoc" ]
then
    uploadToFir
fi

if [ ${BUILD_TYPE} == "inhouse" ]
then
    uploadToFir
fi

# if [ ${BUILD_TYPE} != "appstore" ]; then
#     rm -rf out
# fi
