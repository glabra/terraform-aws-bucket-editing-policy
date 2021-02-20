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
    sid = "1"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:HeadBucket",
    ]
    resources = ["*"]
  }
  
  statement {
    sid = "2"
    actions = [
      "s3:*Object",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListBucketMultipartUploads",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
    ]
    resources = flatten([for s in var.s3_bucket_arns : [s, "${s}/*"]])
  }
}

resource "aws_iam_policy" "policy" {
  policy = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user = var.iam_user_name
  policy_arn = aws_iam_policy.policy.arn
}