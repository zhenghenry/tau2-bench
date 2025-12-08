#!/bin/bash


MODEL_ID=${MODEL_ID:-smoe}
DOMAIN=${DOMAIN:-airline}
USER_LLM=${USER_LLM:-gpt-4.1}
NUM_TRIALS=${NUM_TRIALS:-3}
NUM_TASKS=${NUM_TASKS:-50}
PROVIDER=${PROVIDER:-openai}

tau2 run \
    --agent-llm-args '{"api_key": "asdf1324", "api_base": "http://localhost:8000/v1", "max_tokens": 8192, "max_completion_tokens": 16384}' \
    --domain $DOMAIN \
    --agent-llm $MODEL_ID \
    --user-llm gpt-4.1 \
    --num-trials $NUM_TRIALS \
    --num-tasks $NUM_TASKS \
    --max-concurrency 3 \
    --save-to ${DOMAIN}_${MODEL_ID}_${USER_LLM}_${NUM_TRIALS}_${NUM_TASKS}.json \
    --max-steps 20 \
    --max-errors 10 \
    --seed 300 \
    --log-level ERROR