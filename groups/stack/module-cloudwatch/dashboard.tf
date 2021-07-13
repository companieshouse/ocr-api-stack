resource "aws_cloudwatch_dashboard" "ocr_service_dashboard" {
  dashboard_name = "OCR-Service-${var.environment}"

  dashboard_body = templatefile("${path.module}/dashboard.tmpl", {
      environment             : var.environment
      aws_region              : var.aws_region
      elb_arn_suffix          : var.elb_arn_suffix
      target_group_arn_suffix : var.target_group_arn_suffix
  })

}
