variable "aws_region" {
  default = "ap-southeast-1"
}

variable "ec2_ami" {
  description = "Amazon Linux 2 AMI for ap-southeast-1"
  default     = "ami-0df7a207adb9748c7"
}

variable "s3_bucket_name" {
  description = "Must be globally unique"
  default     = "260323-test-s3-bucket"
}