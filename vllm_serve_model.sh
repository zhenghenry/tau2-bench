#!/bin/bash


MODEL_ID=${MODEL_ID:-/checkpoints/iter_0041723_reasoning}

vllm serve $MODEL_ID \
    --tensor-parallel-size 1 \
    --enable-auto-tool-choice \
    --tool-call-parser hermes \
    --host 0.0.0.0 \
    --seed 0 \
    --dtype bfloat16 \
    --gpu-memory-utilization 0.9 \
    --max-model-len 32768 \
    --no-enable-prefix-caching \
    --max-seq-len-to-capture 32768 \
    --port 8000 