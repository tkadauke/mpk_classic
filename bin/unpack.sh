#!/bin/bash

PASSWORD="soho0909"

for model in models/*.io; do
  filename="$(basename -- "$model")"
  model_name="${filename%.*}"

  mkdir -p "src/${model_name}"
  unzip -P "$PASSWORD" -o "$model" -d "src/${model_name}"

  if [ -f "src/${model_name}/model.ins" ]; then
    tidy -xml -indent -modify "src/${model_name}/model.ins"
  fi
done
