#!/bin/bash

grep "^$1" Cargo.toml | sed -e "s/$1 = { alias = \"/.\/src\/bin\//g" -e "s/\".*/.rs/g" | xargs cat