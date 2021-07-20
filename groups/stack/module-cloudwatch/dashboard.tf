resource "aws_cloudwatch_dashboard" "ocr_api_dashboard" {
  dashboard_name = "ocr-api-${var.environment}"

  dashboard_body = templatefile("${path.module}/dashboard.tmpl", {
      environment             : var.environment
      aws_region              : var.aws_region
      elb_arn_suffix          : var.elb_arn_suffix
  })

}
