/*
output "aws_ami" {
    value = module.myapp-server.aws_ami.latest-amazon-linux-image
}
*/

output "ec2-public_ip" {
    value = module.myapp-server.instance.public_ip
}
