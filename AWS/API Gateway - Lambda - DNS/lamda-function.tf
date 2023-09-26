resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "graphql_server" {
  function_name = "parent-portal-graphql"
  
  # The bucket name where the source code is stored"
  s3_bucket = "nww-parent-portal-dev"
  s3_key    = "v1.0.0/lambda.zip"

  runtime = "nodejs18.x"
  handler = "index.graphqlHandler"

  role = aws_iam_role.lambda_exec.arn
  tags = var.tags
}