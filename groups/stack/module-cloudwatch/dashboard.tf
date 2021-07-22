resource "aws_cloudwatch_log_metric_filter" "requests-on-queue_metric_filter" {
  name           = "requests-on-queue-${var.environment}"
  pattern        = "{ ($.data.log_record_name = \"ocr_statistics\") && ($.data.queue_size > 0) }"
  log_group_name = "/ecs/ocr-api-${var.environment}/ocr-api"

 # Support for unit attribute in Add support for unit 3.47.0 (June 24, 2021) https://github.com/hashicorp/terraform-provider-aws/blob/main/CHANGELOG.md
 # ideally set: unit = "Count"
  metric_transformation {
    name          = "queue-size-above-zero"
    namespace     = "ocr-api-metrics-${var.environment}"
    value         = "$.data.queue_size"
    default_value = 0
  }
}


resource "aws_cloudwatch_dashboard" "ocr_api_dashboard" {
  dashboard_name = "ocr-api-${var.environment}"

  dashboard_body = templatefile("${path.module}/dashboard.tmpl", {
      environment             : var.environment
      aws_region              : var.aws_region
      elb_arn_suffix          : var.elb_arn_suffix
  })

}

