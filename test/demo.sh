#!/usr/bin/env bash
Content=$(curl http://demo-service-uat.demo-axa.co.uk)
ContentB="HELLO THIS IS THE DEMO version 1.1"
#ContentB="HELLO THIS IS THE AXA DEMO version 1.1"
#ContentB="Page Under Construction"

if [ "$Content" = "$ContentB" ]; then
    echo "Content Matched"
else
    echo "Content is NOT Matched"
	exit 64
fi;