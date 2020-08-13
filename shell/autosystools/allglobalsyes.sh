#!/bin/bash
#######################################################
# Shell script to seach for and turns off all global  #
# variables with *_up.                                #
# author: David Uyekq                                 #
# date : 1/24/2019                                    #
#                                                     #
# Script runs a autorep on all global variables using #
# the wildcard %_up% and exports it to a list.        #
# The list is then read line by line and runs the     #
# sendevent to turn them on in an emergency or for  #
# maintenance.                                        #
#######################################################

autorep -G %_up% | grep _up | awk {'print $1'} >allglobals.txt

cat allglobals.txt | while read line
do
        sendevent -S TTS -E SET_GLOBAL -G "$line=yes"
	done
	rm allglobals.txt
