#!/bin/bash


####################
#About: This is a basic script to monitor the system performance and to analyze the health of software and hardware
#Input: 
###################


top -b -n 1 | head -5

df
