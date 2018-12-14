#!/bin/bash

# Recursively remove .DS_Store files from current directory

find . -name '.DS_Store' -type f -delete
