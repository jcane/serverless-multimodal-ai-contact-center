resource "aws_lambda_layer_version" "stripe_python" {
  filename            = "${path.module}/../Layers/stripe-python.zip"
  layer_name          = "stripe-python-layer-Fixyachips-App-V1"
  compatible_runtimes = ["python3.11"]
  description         = "Stripe Python SDK layer"
}
