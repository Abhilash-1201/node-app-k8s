#!/bin/bash
sed "s/tagVersion/$1/g" pods.yml > javawebapp-pod.yml
