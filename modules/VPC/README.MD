Terraform VPC Module: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

Provider Dependencies
Providers are Terraform plugins that will be automatically installed during terraform init if available on the Terraform Registry.

aws (hashicorp/aws) >= 5.46



VPC module contains:
Subnet
internet gateway
Route Table




NAT Gateway Scenarios
This module supports three scenarios for creating NAT gateways. Each will be explained in further detail in the corresponding sections.

One NAT Gateway per subnet (default behavior)
enable_nat_gateway = true
single_nat_gateway = false
one_nat_gateway_per_az = false
Single NAT Gateway
enable_nat_gateway = true
single_nat_gateway = true
one_nat_gateway_per_az = false
One NAT Gateway per availability zone
enable_nat_gateway = true
single_nat_gateway = false
one_nat_gateway_per_az = true
If both single_nat_gateway and one_nat_gateway_per_az are set to true, then single_nat_gateway takes precedence.

One NAT Gateway per subnet (default)
By default, the module will determine the number of NAT Gateways to create based on the max() of the private subnet lists (database_subnets, elasticache_subnets, private_subnets, and redshift_subnets). The module does not take into account the number of intra_subnets, since the latter are designed to have no Internet access via NAT Gateway. For example, if your configuration looks like the following:

database_subnets    = ["10.0.21.0/24", "10.0.22.0/24"]
elasticache_subnets = ["10.0.31.0/24", "10.0.32.0/24"]
private_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
redshift_subnets    = ["10.0.41.0/24", "10.0.42.0/24"]
intra_subnets       = ["10.0.51.0/24", "10.0.52.0/24", "10.0.53.0/24"]
Copy
Then 5 NAT Gateways will be created since 5 private subnet CIDR blocks were specified.

Single NAT Gateway
If single_nat_gateway = true, then all private subnets will route their Internet traffic through this single NAT gateway. The NAT gateway will be placed in the first public subnet in your public_subnets block.

One NAT Gateway per availability zone
If one_nat_gateway_per_az = true and single_nat_gateway = false, then the module will place one NAT gateway in each availability zone you specify in var.azs. There are some requirements around using this feature flag:

The variable var.azs must be specified.
The number of public subnet CIDR blocks specified in public_subnets must be greater than or equal to the number of availability zones specified in var.azs. This is to ensure that each NAT Gateway has a dedicated public subnet to deploy to.
"private" versus "intra" subnets
By default, if NAT Gateways are enabled, private subnets will be configured with routes for Internet traffic that point at the NAT Gateways configured by use of the above options.

If you need private subnets that should have no Internet routing (in the sense of RFC1918 Category 1 subnets), intra_subnets should be specified. An example use case is configuration of AWS Lambda functions within a VPC, where AWS Lambda functions only need to pass traffic to internal resources or VPC endpoints for AWS services.

Since AWS Lambda functions allocate Elastic Network Interfaces in proportion to the traffic received (read more), it can be useful to allocate a large private subnet for such allocations, while keeping the traffic they generate entirely internal to the VPC.

You can add additional tags with intra_subnet_tags as with other subnet types.

