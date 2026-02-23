resource "aws_cloudwatch_log_group" "strapi" {
  name              = "/ecs/${var.app_name}"
  retention_in_days = 7
  tags = { Name = "${var.app_name}-logs" }
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.app_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alert when CPU exceeds 80%"
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.strapi.name
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "${var.app_name}-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alert when Memory exceeds 80%"
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.strapi.name
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.app_name}-alb-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "Alert when ALB 5XX errors exceed 10"
  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }
}

resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "${var.app_name}-error-filter"
  pattern        = "ERROR"
  log_group_name = aws_cloudwatch_log_group.strapi.name

  metric_transformation {
    name      = "${var.app_name}-error-count"
    namespace = "Strapi/Errors"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "app_errors" {
  alarm_name          = "${var.app_name}-app-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "${var.app_name}-error-count"
  namespace           = "Strapi/Errors"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "Alert when app errors exceed 5"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "bedrock_filter" {
  name           = "${var.app_name}-bedrock-filter"
  pattern        = "bedrock"
  log_group_name = aws_cloudwatch_log_group.strapi.name

  metric_transformation {
    name      = "${var.app_name}-bedrock-calls"
    namespace = "Strapi/Bedrock"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "bedrock_errors" {
  alarm_name          = "${var.app_name}-bedrock-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "${var.app_name}-bedrock-calls"
  namespace           = "Strapi/Bedrock"
  period              = 60
  statistic           = "Sum"
  threshold           = 100
  alarm_description   = "Alert when Bedrock calls exceed 100 per minute"
  treat_missing_data  = "notBreaching"
}
