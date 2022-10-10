I will not upload any important data to any cloud without encryption.  :)

So, I wrote these scripts to encrypt and decrypt important folders.
encryption:
run enc-folder.sh to encrypt a folder, then I can uploaded the encrypted file to cloud such as google drive.

enc-folder.sh will encrypt the folder you specified and delete the folder after encryption. Because sometimes my kids use my computer, I don't want them to mess my data.


decryption:
run dec-folder.sh to decrypt the encrypted file back to a folder.
Then I can edit the files in the folder.
When I finished editing, I run enc-folder.sh to encrypt it again.

usage:
./enc-folder.sh folder_name
./dec-folder.sh encrypted_file.tar.gz
