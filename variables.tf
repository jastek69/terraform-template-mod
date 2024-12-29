# Variable definitions - set as values from .tfvars file and passed to child modules
variable vpc_cidr_blocks {}
#variable subnet_cidr_block {}

variable avail_zone {}
/*
variable avail_zone {
    type = list(object({
        az = string
        subnet_cidr_block = string
    }))
}
*/

variable env_prefix {}
variable instance_type {} # for AMI t2 or t3 micro
variable image_name {} # for AMI
variable key_name {} # for AMI
