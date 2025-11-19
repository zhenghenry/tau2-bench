#!/bin/bash


MODEL_ID=${MODEL_ID:-smoe}
DOMAIN=${DOMAIN:-airline}

tau2 run \
    --agent-llm-args '{"api_key": "asdf1324", "api_base": "http://localhost:8000/v1", "max_tokens": 4096}' \
    --domain $DOMAIN \
    --agent-llm $MODEL_ID \
    --user-llm gpt-4.1 \
    --num-trials 1