resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_blocks[0].cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

module "myapp-subnet" {
    source = "./modules/subnet"
    vpc_cidr_blocks = var.vpc_cidr_blocks       
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.myapp-vpc.id
    #default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id  #Enable to use default route table
}

module myapp-server {
    source = "./modules/webserver"
    vpc_id = aws_vpc.myapp-vpc.id
    vpc_cidr_blocks = var.vpc_cidr_blocks
    env_prefix = var.env_prefix
    image_name = var.image_name
    key_name = var.key_name
    avail_zone = var.avail_zone
    instance_type = var.instance_type
    subnet_id = module.myapp-subnet.subnet.id    
}
