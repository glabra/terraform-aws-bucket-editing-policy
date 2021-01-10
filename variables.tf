variable "iam_user_name" {
  type = string
  description = "Provides S3 read/write access to this user"
}

variable "s3_bucket_arns" {
  type = list(string)
  description = "S3 bucket ARNs to provide read/write access"
}
