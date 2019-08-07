#!/bin/bash

PASSWORD="soho0909"
mkdir -p models

for model_src in src/*; do
  model_name="$(basename -- "$model_src")"
  outfile="models/${model_name}.io"
  rm "$outfile"
  zip -e -j -P "$PASSWORD" "$outfile" "${model_src}"/* "${model_src}/.info"
done
