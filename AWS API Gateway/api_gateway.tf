resource "aws_apigatewayv2_api" "main" {
  name          = "appmesh-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "dev" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "dev"
  auto_deploy = true
}

resource "aws_security_group" "vpc-link" {
  name   = "vpclink-sg"
  vpc_id = aws_vpc.appmesh-vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_apigatewayv2_vpc_link" "main" {
  name               = "appmesh-vpclink"
  subnet_ids         = [aws_subnet.private-us-east-1a.id, aws_subnet.private-us-east-1b.id]
  security_group_ids = [aws_security_group.vpc-link.id]
}

resource "aws_apigatewayv2_integration" "main" {
  api_id             = aws_apigatewayv2_api.main.id

  integration_uri    = "arn:aws:elasticloadbalancing:us-east-1:865892152366:listener/net/ab1213e767d4446b3a3d3b3626021cfc/635717608a3936bd/9628f1c1187f6807"
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.main.id
}

resource "aws_apigatewayv2_route" "route-eks" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /echo"
  target    = "integrations/${aws_apigatewayv2_integration.main.id}"
}

output "urt" {
  value = "${aws_apigatewayv2_stage.dev.invoke_url}/echo"

}