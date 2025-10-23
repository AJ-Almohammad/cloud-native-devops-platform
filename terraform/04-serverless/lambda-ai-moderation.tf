resource "aws_lambda_function" "ai_moderation" {
  filename      = "../../lambdas/ai-moderation/lambda.zip"
  function_name = "multi-everything-ai-moderation"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"  # ✅ Fixed
  runtime       = "python3.9"
  timeout       = 30

  environment {
    variables = {
      OPENAI_API_KEY = var.openai_api_key
    }
  }

  tags = {
    Name        = "multi-everything-ai-moderation"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ai_moderation.function_name
  principal     = "apigateway.amazonaws.com"
}
