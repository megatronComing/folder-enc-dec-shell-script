#!/bin/bash

help()
{
    echo ""
    echo "usage: ${0} INPUT_FILE_NAME"
    echo "INPUT_FILE_NAME should ends with .tar.gz.enc"
    echo ""
}
if [ $# -ne 1 ]; then
    help
    exit -1
fi
if [[ "$1" == *".tar.gz.enc"* ]]; then
    FILE_ENC=$1
    FILE_TAR=${FILE_ENC%.enc*}
    FOLDER2TAR=${FILE_TAR%.tar.gz}
else
    help
    exit -2    
fi

printf -- '-%.0s' {1..80}
printf '\n'
echo -e "\tDecrypt file [$FILE_ENC], save to folder [$FOLDER2TAR]"

if [ ! -f $FILE_ENC ]; then
    echo "file [$FILE_ENC] not exist"
    exit 1
fi
echo "decrypting file [$FILE_ENC]"
#change the number after -iter according to your computer's CPU, the bigger the number is, the better the encryption is.
openssl aes-256-cbc -d -a -pbkdf2 -iter 1000000 -in $FILE_ENC -out $FILE_TAR
if [ ! $? -eq 0 ]; then
    echo "decryption $FILE_ENC FAILED"
    exit 2
fi
echo "[$FILE_ENC] decrypted to [$FILE_TAR]"
tar -xzf $FILE_TAR
if [ ! $? -eq 0 ]; then
    echo "FAILED to unzip file [$FILE_TAR]"
    exit 3
fi
echo "file [$FILE_TAR] unzipped"
rm -rf $FILE_TAR
if [ ! $? -eq 0 ]; then
    echo "FAILED to delete file [$FILE_TAR]"
    exit 4
fi
echo "file [$FILE_TAR] deleted"
echo "Done."
