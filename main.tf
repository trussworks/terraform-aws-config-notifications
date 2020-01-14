/**
 * Enables AWS Config and configures any compliance changes or AWS Config service
 * changes to be sent to an SNS topic.
 *
 * Creates the following resources:
 *
 * * CloudWatch event rules to filter
 *   * AWS Config compliance changes
 *   * Changes to the AWS Config service
 * * CloudWatch event targets to send notifications to an SNS topic
 *
 * ## Usage
 *
 * ```hcl
 * module "config-notifications" {
 *   source = "trussworks/config-notifications/aws"
 *   version = "1.0.0"
 *
 *   sns_topic_name = "slack-events"
 * }
 * ```
 */

#
# SNS
#

data "aws_sns_topic" "main" {
  name = var.sns_topic_name
}

#
# CloudWatch Event
#

resource "aws_cloudwatch_event_rule" "compliance_event" {
  name          = "awsconfig-compliance-events"
  description   = "AWS Config compliance events"
  event_pattern = file("${path.module}/compliance-event-pattern.json")
}

resource "aws_cloudwatch_event_target" "compliance_event" {
  rule      = aws_cloudwatch_event_rule.compliance_event.name
  target_id = "send-to-sns"
  arn       = data.aws_sns_topic.main.arn

  input_transformer {
    input_paths = {
      rule     = "$.detail.configRuleName"
      resource = "$.detail.resourceId"
      status   = "$.detail.newEvaluationResult.complianceType"
    }

    input_template = "\"AWS Config Compliance Change: Rule <rule> triggered for resource <resource>.  New Status: <status>.\""
  }
}

resource "aws_cloudwatch_event_rule" "config_event" {
  name          = "awsconfig-events"
  description   = "AWS Config events"
  event_pattern = file("${path.module}/config-event-pattern.json")
}

resource "aws_cloudwatch_event_target" "config_event" {
  rule      = aws_cloudwatch_event_rule.config_event.name
  target_id = "send-to-sns"
  arn       = data.aws_sns_topic.main.arn

  input_transformer {
    input_paths = {
      event      = "$.detail.eventName"
      parameters = "$.detail.requestParameters"
    }

    input_template = "\"AWS Config Change: Event <event> with request parameters: <parameters>.\""
  }
}

