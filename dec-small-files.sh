#!/bin/bash


FOLDER2TAR="small-files"
FILE_TAR="small-files.tar.gz"
FILE_ENC="${FILE_TAR}.enc"

if [ ! -f $FILE_ENC ]; then
    echo "file [$FILE_ENC] not exist"
    exit 1
fi
echo "decrypting file [$FILE_ENC]"
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
