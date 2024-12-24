
output "aws-ami_id" {
    value = data.aws_ami.latest-amazon-linux-image
}


output "ec2-public_ip" {
    value = aws_instance.myapp-server.public_ip
}
