# Note that we need to patch Zvllm a bit because we will need tool calling and SMOE does not have tool_call tokens in the vocab
# In `hermes_tool_parser.py` change line 60 to `logger.warning` instead of `raise`.

