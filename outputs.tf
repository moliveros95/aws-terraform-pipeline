output "ec2_public_ip" {
  value = aws_instance.main.public_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.main.bucket
}

output "vpc_id" {
  value = aws_vpc.main.id
}