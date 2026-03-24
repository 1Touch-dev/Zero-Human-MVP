#!/bin/bash
openclaw models set openai/gpt-4o
mkdir -p ~/.openclaw/agents/main/agent
cat << EOF > ~/.openclaw/agents/main/agent/auth-profiles.json
{
  "openai": {
    "base": {
      "apiKey": "$OPENAI_API_KEY"
    }
  }
}
EOF
openclaw models | head -n 25
