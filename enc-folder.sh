#!/bin/bash

help()
{
    echo ""
    echo "usage: ${0} INPUT_FOLDER_NAME"
    echo ""
}

if [ $# -ne 1 ]; then
    help
    exit -1
fi
FOLDER2TAR=$1
FILE_TAR="${FOLDER2TAR}.tar.gz"
FILE_ENC="${FILE_TAR}.enc"

printf -- '-%.0s' {1..80}
printf '\n'
echo -e "\tcompress and encrypt folder [$FOLDER2TAR]"
# check whether the source folder exists
if [ ! -d $FOLDER2TAR ]; then
        echo -e "\tdirectory [$FOLDER2TAR] NOT exists"
        exit 1
fi

# if the destination file exists, confirm to replace it.
if [ -f $FILE_TAR ]; then
        echo -e "\tWARNING: file [$FILE_TAR] should NOT exist, delete it!"
        echo -e "\toperation CANCELED"
        exit 2
fi
if [ -f $FILE_ENC ]; then
        today=`date +%Y%m%d%H%M%S`
        mv $FILE_ENC "${FILE_ENC}.bak.${today}"
        if [ ! $? -eq 0 ]; then
            echo -e "\tFAILED to backup file [$FILE_ENC]"
            exit 3
        fi
        echo -e "\t[$FILE_ENC] backuped to [${FILE_ENC}.bak]"

fi

#compress the dir, exit when error occures
echo -e "\tcompressing folder [$FOLDER2TAR] to [$FILE_TAR]"
tar -czf $FILE_TAR $FOLDER2TAR
if [ ! $? -eq 0 ]; then
        echo "FAILED"
        echo -e "\tERROR compressing folder [$FOLDER2TAR] to [$FILE_TAR]"
        exit 4
fi
echo -e "\tcompression done"

echo -e "\tencrypting file [$FILE_TAR]"
openssl aes-256-cbc -a -salt -pbkdf2 -iter 1000000 -in $FILE_TAR -out $FILE_ENC
if [ ! $? -eq 0 ]; then
    echo "FAILED"
    echo -e "\tERROR encrypting [$FILE_TAR]"
    exit 5
fi
echo -e "\tENCRYPTION done"
echo -e "\t[$FILE_TAR] encrypted to [$FILE_ENC]"

rm -rf $FOLDER2TAR
if [ ! $? -eq 0 ]; then
    echo -e "\tERROR deleting folder [$FOLDER2TAR]"
    exit 6
fi
echo -e "\tfolder [$FOLDER2TAR] deleted"
rm -rf "$FILE_TAR"
if [ ! $? -eq 0 ]; then
    echo -e "\tERROR deleting tar file [$FILE_TAR]"
    exit 7
fi
echo -e "\tfile [$FILE_TAR] deleted"
printf -- '-%.0s' {1..80}
printf '\n'
echo -e "\tDone."
exit 0
