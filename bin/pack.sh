#!/bin/bash

PASSWORD="soho0909"

for model_src in src/*; do
  model_name="$(basename -- "$model_src")"
  zip -e -P "$PASSWORD" "models/${model_name}.io" "${model_src}"/* "${model_src}/.info"
done
