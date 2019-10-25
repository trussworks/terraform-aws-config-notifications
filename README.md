<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Enables AWS Config and configures any compliance changes or AWS Config service
changes to be sent to an SNS topic.

Creates the following resources:

* CloudWatch event rules to filter
  * AWS Config compliance changes
  * Changes to the AWS Config service
* CloudWatch event targets to send notifications to an SNS topic

## Usage

```hcl
module "config-notifications" {
  source = "trussworks/config-notifications/aws"
  version = "1.0.0"

  sns_topic_name = "slack-events"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| sns\_topic\_name | The name of the SNS topic to send AWS Config notifications. | string | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
