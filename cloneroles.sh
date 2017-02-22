#!/bin/bash
cd roles
for r in `grep src ../requirements.yml|grep https|awk '{print $3}'`;
do
    git clone $r;
done
