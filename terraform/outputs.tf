output "ec2_public_ip" {
  value = aws_instance.ghost.public_ip
}
