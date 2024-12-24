resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = var.vpc_id
    cidr_block = var.vpc_cidr_blocks[1].cidr_block
    availability_zone = var.avail_zone[0].az
        tags = {
        Name: "${var.env_prefix}-subnet-1a"
    }
}


resource "aws_subnet" "myapp-subnet-2" {
    vpc_id = var.vpc_id
    cidr_block = var.vpc_cidr_blocks[2].cidr_block
    availability_zone = var.avail_zone[1].az
        tags = {
        Name: "${var.env_prefix}-subnet-1c"
    }
}

# Internet Gateway
# IGW Tells Route Table to handle requests from Internet
resource "aws_internet_gateway" "myapp-igw" {   #resource aig is available within same module so do not need to replace with var
    vpc_id = var.vpc_id
    tags = {
        Name: "${var.env_prefix}-igw"
        }    
    }


# Route Table
resource "aws_route_table" "myapp-route-table" {
    vpc_id = var.vpc_id

    #connect to IGW
    route {                         
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
        Name: "${var.env_prefix}-rtb"
        }
    }    


 resource "aws_route_table_association" "a-rtb-subnet1a" {
    subnet_id = aws_subnet.myapp-subnet-1.id            
    route_table_id = aws_route_table.myapp-route-table.id
 }

 resource "aws_route_table_association" "a-rtb-subnet1c" {
    subnet_id = aws_subnet.myapp-subnet-2.id            
    route_table_id = aws_route_table.myapp-route-table.id
 }



# Default RTB association for IGW - other option instead creating a Route Table
/*
resource "aws_default_route_table" "default-rtb" {
    default_route_table_id = var.default_route_table_id     
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
        Name: "${var.env_prefix}main-rtb"
    }
}
*/
