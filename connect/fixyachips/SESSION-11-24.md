
## ARCHITECTURE DECISION — READ BEFORE BUILDING BEDROCK
## ======================================================
## Decision: USE S3 VECTORS (not OpenSearch Serverless)
## Reason:   OpenSearch Serverless = ~$700/month idle minimum
##           S3 Vectors            = ~$2/month idle
##           Prompt Caching option = $0/month idle
##
## FOR 200 Q&A LIBRARY SPECIFICALLY:
##   File size is small (~30KB text)
##   Option B (Prompt Caching) = $0 idle, viable right now
##   Option A (S3 Vectors)     = $2 idle, better for growth
##   SKIP OpenSearch entirely
##
## BEFORE BUILDING BEDROCK KB — DECIDE:
##   Q1: Will library stay ~200 questions? → Prompt Caching
##   Q2: Will it grow to 1000+ documents?  → S3 Vectors
##   Either way: NO OpenSearch Serverless

## ARCHITECTURE DECISION — LOCKED
## ================================
## Vector Store: S3 VECTORS
## Reason 1: Library stays ~200 questions → Prompt Caching handles runtime
## Reason 2: Building IaC Marketplace template → S3 Vectors is the 
##            clean, professional, sellable architecture
## Reason 3: $2/month idle vs $700/month OpenSearch
##
## NEVER USE: OpenSearch Serverless for this project
##
## Prompt Caching: ALSO ENABLED on top of S3 Vectors
##   - S3 Vectors handles the RAG retrieval layer
##   - Prompt Caching handles the system prompt + routing rules
##   - Both together = best cost + best architecture for a template product
##
## Date decided: 11/24
## Decision maker: Joshua Cane
