# API Gateway invoke output
output "api_gateway_invoke_url" {
  value = "${aws_apigatewayv2_stage.environment.invoke_url}/${var.ROUTE_NAME}"
}

# API Gateway route mapping
output "custom_domain_api" {
  value = "https://${aws_apigatewayv2_api_mapping.api.domain_name}"
}

output "custom_domain_api_v1" {
  value = "https://${aws_apigatewayv2_api_mapping.api_v1.domain_name}/${aws_apigatewayv2_api_mapping.api_v1.api_mapping_key}"
}