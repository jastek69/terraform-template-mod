/*
Webserver Module consists of:
    * ami Instance - data type
    * Key pair -> use key_name = "MyLinuxBox" 
* Security Group for the Firewalls - resource

*/

/*******************************************************************************/
# Security Groups - Firewall Settings

#Target Group for Port 80 app
resource "aws_security_group" "myapp-sg-80" {
  name        = "myapp-sg-80"
  description = "myapp-sg-80"
  vpc_id      = var.vpc_id

  ingress {
    description = "MyHomePage"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks = var.vpc_cidr_blocks[0].cidr_block
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    #Name    = "myapp-sg-80"
    Name: "${var.env_prefix}-sg-80"
    Service = "application1"
    Owner   = "Balactus"
    Planet  = "Taa"
  }

}


# Port 443 Security Group for Syslog Server 443 - add ingress for 443
resource "aws_security_group" "myapp-sg-443" {
  name        = "myapp-sg-443"
  description = "myapp-sg-443"
  vpc_id      = var.vpc_id

  ingress {
    description = "MyHomePage"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Secure"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    #Name    = "myapp-sg-443"
    Name: "${var.env_prefix}-sg-443"
    Service = "application1"
    Owner   = "Blackneto"
    Planet  = "Taa"
  }
}


#latest image  

data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = [var.image_name]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}


resource "aws_instance" "myapp-server" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type[0]
    
    subnet_id = var.subnet_id #Subnet 1A
    vpc_security_group_ids = [
        aws_security_group.myapp-sg-80.id,
        aws_security_group.myapp-sg-443.id
    ]

    associate_public_ip_address = true # 
    
    availability_zone = var.avail_zone

    # key_name = "MyLinuxBox"
    key_name = var.key_name
    

    user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd

    # Get the IMDSv2 token
    TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

    # Background the curl requests
    curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4 &> /tmp/local_ipv4 &
    curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone &> /tmp/az &
    curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ &> /tmp/macid &
    wait

    macid=$(cat /tmp/macid)
    local_ipv4=$(cat /tmp/local_ipv4)
    az=$(cat /tmp/az)
    vpc=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$macid/vpc-id)

    # Create HTML file
    cat <<-HTML > /var/www/html/index.html
    <!doctype html>
    <html lang="en" class="h-100">
    <head>
    <title>Details for EC2 instance</title>
    </head>
    <body>
    <div>
    <h1>Balactus has Arrived in nyctralia</h1>
    <h1>Keisha World has been consumed</h1>
    <p><b>Instance Name:</b> $(hostname -f) </p>
    <p><b>Instance Private Ip Address: </b> $local_ipv4</p>
    <p><b>Availability Zone: </b> $az</p>
    <p><b>Virtual Private Cloud (VPC):</b> $vpc</p>
    </div>
    </body>
    </html>
    HTML

    # Clean up the temp files
    rm -f /tmp/local_ipv4 /tmp/az /tmp/macid
  EOF
  )

  tags = {
     Name: "${var.env_prefix}-server"
     Service = "application1"
     Owner   = "Blackneto"
     Planet  = "Taa"
  }

  lifecycle {
    create_before_destroy = true
  }
}



/**********************************************************************************************************************************************/

/*

# Default RTB association for IGW - other option instead creating a Route Table

resource "aws_default_route_table" "default-rtb" {
    default_route_table_id = var.default_route_table_id     
                                                                        
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
        Name: "${var.env_prefix}-rtb"
    }    
}
*/
