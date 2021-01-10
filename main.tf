terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.22.0"
    }
  }
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "s3:ListAllMyBuckets",
    ]
    resources = ["*"]
  }
  
  statement {
    actions = ["s3:ListBucket"]
    resources = var.s3_bucket_arns
  }
  statement {
    actions = ["s3:*Object"]
    resources = [for s in var.s3_bucket_arns : "${s}/*"]
  }
}

resource "aws_iam_policy" "policy" {
  policy = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user = var.iam_user_name
  policy_arn = aws_iam_policy.policy.arn
}