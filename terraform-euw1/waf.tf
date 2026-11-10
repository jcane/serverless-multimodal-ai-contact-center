# ============================================================
# waf.tf
# WAF EXCLUDED FROM EU-WEST-1 DEPLOYMENT
#
# AWS REQUIREMENT: CloudFront WAF Web ACLs must be created
# in us-east-1 regardless of CloudFront distribution region.
# Reference: https://docs.aws.amazon.com/waf/latest/developerguide/
#
# WAF for this CloudFront distribution is managed in the
# us-east-1 stack via CloudFormation.
#
# To add WAF here: create a separate terraform workspace
# targeting us-east-1 and associate the ACL ARN via
# cloudfront.tf web_acl_id parameter.
# ============================================================
