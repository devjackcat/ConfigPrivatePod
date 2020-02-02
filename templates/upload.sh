#!/bin/bash

set -u # 遇到未定义的变量时报错
set -e # 遇到错误时终止当前脚本执行
#set -x # 调试执行

#VersionString=`grep -E 's.version.*=' JCTheme.podspec`
#VersionNumber=`tr -cd 0-9 <<<"$VersionString"`

#NewVersionNumber=$(($VersionNumber + 1))
#LineNumber=`grep -nE 's.version.*=' JCTheme.podspec | cut -d : -f1`
#sed -i "" "${LineNumber}s/${VersionNumber}/${NewVersionNumber}/g" __ProjectName__.podspec

gitsource=https://gitee.com/devjackcat/JCS_PodSpecs.git,https://cdn.cocoapods.org/

# 采集Tag
tag=""
getTagName() {
    read -p "Enter Tag Name: " tag
    if test -z "$tag"; then
        getTagName
    fi
}
getTagName

# 验证podspec文件是否合法
pod lib lint __ProjectName__.podspec --sources=${gitsource}  --verbose --allow-warnings --use-libraries

LineNumber=`grep -nE 's.version.*=' __ProjectName__.podspec | cut -d : -f1`
sed -i "" "${LineNumber}s/^\([ ]*s.version[ ]*=[ ]*\"\)\(.*\)\(\"[ ]*\)$/\1${tag}\3/g" __ProjectName__.podspec

git add .
git commit -am ${tag}
git tag ${tag}
git push origin master --tags
# 提交到私有库
pod repo push JCS_PodSpecs __ProjectName__.podspec --sources=${gitsource} --verbose --allow-warnings --use-libraries --use-modular-headers
#提交到公开库
#pod trunk push __ProjectName__.podspec --verbose --allow-warnings --use-libraries

