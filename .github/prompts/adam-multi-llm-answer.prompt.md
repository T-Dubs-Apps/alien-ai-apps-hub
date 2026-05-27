---
name: "ADAM Multi-LLM Answer"
description: "Generate one ultra-smart response by combining outputs from multiple LLMs through Agent ADAM"
agent: "Agent ADAM"
argument-hint: "Enter the question or task ADAM should solve using multi-LLM consensus"
---
Use Agent ADAM to solve the following request using a multi-LLM synthesis workflow.

User task:

{{input}}

Requirements:
- Use multiple available model perspectives.
- Compare outputs and identify consensus and disagreements.
- Merge the strongest reasoning into one final response.
- Include confidence and limits.
- If some models are unavailable, proceed with available models and note the limitation.

Return in this format:
1. Final Answer
2. Consensus Summary
3. Conflicts and Resolution
4. Confidence and Limits
