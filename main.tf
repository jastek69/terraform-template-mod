
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"# point to the online module in the registry

  name = "my-vpc"
  cidr = var.vpc_cidr_blocks[0].cidr_block

  azs             = ["ap-northeast-1a"]
  public_subnets  = [var.vpc_cidr_blocks[1].cidr_block, var.vpc_cidr_blocks[2].cidr_block]
  private_subnets = [var.vpc_cidr_blocks[3].cidr_block, var.vpc_cidr_blocks[4].cidr_block]  

  #enable_nat_gateway = true
  #enable_vpn_gateway = true

  #Input Tags (Optional) 
  public_subnet_tags = { Name = "${var.env_prefix}-subnet-1" }
    
  #private_subnet_tags_per_az map(map(string)) #Description: Additional tags for the private subnets where the primary key is the AZ
  private_subnet_tags = { Name = "${var.env_prefix}-subnet-2" }

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}


module myapp-server {
    source = "./modules/webserver"
    vpc_id = module.vpc.vpc_id # from Output list
    vpc_cidr_blocks = var.vpc_cidr_blocks
    env_prefix = var.env_prefix
    image_name = var.image_name
    key_name = var.key_name
    avail_zone = var.avail_zone
    instance_type = var.instance_type
    subnet_id = module.vpc.public_subnets[0] # from Output list
}
