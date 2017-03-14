#/bin/bash

echo "************************************"
echo "         统计项目的代码       "
echo "         author: Dely        "
echo "         微信: Delyer521      "
echo "         邮箱: jiayaoit@126.com "
echo "************************************"


echo "请输入项目绝对路径(如：/Users/admin/Desktop/project):"
read projectPath

#变量定义------------------
#中间文件
tmpFile="./tmpFileName.txt"
#后缀名数组
suffixArray=()
#文件数数组
fileNumArray=()
#统计的总行数
codeLine=0

#函数定义------------------
#1.项目路径
function inputFilePath(){
    while [ ! -e ${projectPath} ]
    do
        echo "请输入正确的项目绝对路径:"
        read projectPath
    done
}

#2.输入要统计文件的后缀名

function inputSuffixName(){
    suffixCount=0
    echo -n '输入你需要统计文件的后缀名（如.h .c .m .swift .java)'
    echo '按下 <CTRL+D> 结束输入'
    while read FILM
    do
    suffixArray[$suffixCount]=$FILM
    let suffixCount++
    done
}



#3.删除缓存文件
function rmCachefile(){
    if [ -e ${tmpFile} ]
    then
        rm ${tmpFile}
    else
        echo "缓存文件不存在"
    fi
}

#4.递归读取文件保存到临时文件中
function readfile(){

    for file in `ls $1`
    do
        #这里的-d表示是一个directory，即目录/子文件夹
    if [ -d $1"/"${file} ]
        then
            #如果子文件夹则递归
        readfile $1"/"${file} ${codeLine}
        else
            #否则就能够读取该文件的地址
            filePath=$1"/"${file}
            #echo "$filePath"
            echo "$filePath" >> ${tmpFile}
        fi
    done

}


#

#5.从临时文件中依次读取文件以及行数
function readLineAndFile(){
    for tmpPath in `cat ${tmpFile}`
    do

        for((i=0;i<${#suffixArray[@]};i++))
        do
            #后缀名
            suffixName=${suffixArray[$i]}
            length=${#suffixName}

            #索引
            let index=${#tmpPath}-${length}

            #截取所得的文件后缀名
            suffix=${tmpPath:index:${length}}

            #比较后缀
            if [[ ${suffix} = ${suffixName} ]]
            then
                line=$(cat ${tmpPath} | wc -l)

                #代码行数
                let codeLine=codeLine+line
                echo "${tmpPath}的代码行数为 ： ${line}"
                #文件个数
                fileNum=${fileNumArray[i]}
                let fileNum++
                fileNumArray[i]=${fileNum}
            fi

        done
    done
}

#输出统计信息
function outputInfo(){
    echo "-----------------------------"
    echo "项目代码总行数为：$codeLine"
    for((i=0;i<${#suffixArray[@]};i++))
    do
    #后缀名
    suffixName=${suffixArray[$i]}
    count=${fileNumArray[$i]}
    echo "${suffixName}文件数为：${count}"
    done
    echo "-----------------------------"

}

#脚本过程
inputFilePath
inputSuffixName
rmCachefile
folder=${projectPath}
cd ${projectPath}
echo "请等待,统计中..."
readfile "."
readLineAndFile
outputInfo
rmCachefile
