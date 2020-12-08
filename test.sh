#!/bin/bash

TEST1=0;
TEST2=0;
TEST3=0;
TEST4=0;

##################### 1 ############################

if [ -z $1 ];
then
    T1PATH="..";
else
    T1PATH=$1;
fi

count=$(find $T1PATH|grep -E '(delete_me|remove_me)'|wc -l)
CNT_SHA=$(find $T1PATH/documents/|grep -v 'for_sha.txt'|sha256sum|cut -d" " -f1)

if [ $count == 0 ] && [ $CNT_SHA == 783761c55e51668d458d99cc57b91de3d0a8c7e6aa9f270c6c86e8ba59959e32 ];
then
    echo "1. Remove OK!";
    TEST1=1;
else
    echo "1. Remove Fail!";
fi

##################### 2 ############################
TEXT_HASH=$(cat $T1PATH/documents/for_sha.txt 2>/dev/null |sha256sum|cut -d" " -f1)

if [ $TEXT_HASH == e20b4759b9ce36cee9b8abf384a9e3fe9dc705a14e45169ab74526cf421fda1f ];
then
    echo "2. Text OK!";
    TEST2=1;
else
    echo "2. Text Fail!";
fi

##################### 3 ############################
PERM_HASH=$(ls -l $T1PATH/scripts/|grep -v "test.sh"|cut -d" " -f1|grep "^-"|sha256sum |cut -d" " -f1)

if [ $PERM_HASH == e0f66254f33d35e8114490afc0bc1ef448f13db36783134bf37fa785669e8371 ];
then
    echo "3. Permission OK!";
    TEST3=1;
else
    echo "3. Permission Fail!";
fi


##################### 4 ############################
rm /mnt/live.txt 2> /dev/null;
echo "Wait 20s, for kill check!";
sleep 20;

LV_HASH=$(cat /mnt/live.txt 2> /dev/null| sha256sum |cut -d" " -f1)

if [ $LV_HASH == 69d97c7e0f9ba2d6408560d951356fc4f1fcb6d0651d253e0b196842e2ca4ae8 ];
then
    echo "4. Kill Fail!";
else
    echo "4. Kill OK!";
    TEST4=1;
fi

# End

if [ $TEST1 == 1 ] && [ $TEST2 == 1 ] && [ $TEST3 == 1 ] && [ $TEST4 == 1 ];
then
    echo "ALL TEST OK!";
    touch /root/sub.me
else
    echo "Fail!";
fi
