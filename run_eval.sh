#!/bin/bash

set -e

# Configuration
MODEL_ID=${MODEL_ID:-/checkpoints/iter_0041723_reasoning}
DOMAIN=${DOMAIN:-airline}
VLLM_PORT=${VLLM_PORT:-8000}

# Function to cleanup background processes
cleanup() {
    echo "Cleaning up..."
    if [ ! -z "$VLLM_PID" ]; then
        echo "Stopping vllm server (PID: $VLLM_PID)..."
        kill $VLLM_PID 2>/dev/null || true
        wait $VLLM_PID 2>/dev/null || true
    fi
}

# Set trap to cleanup on exit
trap cleanup EXIT INT TERM

echo "Starting vllm server..."
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
    --port $VLLM_PORT &

VLLM_PID=$!
echo "vllm server started with PID: $VLLM_PID"

# Wait for vllm server to be ready
echo "Waiting for vllm server to be ready..."
max_attempts=60
attempt=0
while [ $attempt -lt $max_attempts ]; do
    if curl -s http://localhost:$VLLM_PORT/health > /dev/null 2>&1; then
        echo "vllm server is ready!"
        break
    fi
    attempt=$((attempt + 1))
    if [ $attempt -eq $max_attempts ]; then
        echo "ERROR: vllm server failed to start within $max_attempts seconds"
        exit 1
    fi
    sleep 1
done

# Give it a bit more time to fully initialize
sleep 5

echo "Starting evaluation..."
tau2 run \
    --agent-llm-args '{"api_key": "asdf1324", "api_base": "http://localhost:'$VLLM_PORT'/v1", "max_tokens": 4096}' \
    --domain $DOMAIN \
    --agent-llm $MODEL_ID \
    --user-llm gpt-4.1 \
    --num-trials 1

echo "Evaluation completed successfully!"

