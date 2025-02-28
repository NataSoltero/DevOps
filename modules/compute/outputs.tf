output "ec2_ip" {
  value = aws_instance.project.public_ip
}