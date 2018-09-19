#!/bin/bash
function getdir(){
    for file in $1/*
    do
    if test -f $file
    then
            echo $file
    else
            getdir $file
    fi
    done
}
