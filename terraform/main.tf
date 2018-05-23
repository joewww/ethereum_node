# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_instance" "ethereum" {
  instance_type = "t2.medium"
  ami           = "${lookup(var.aws_amis, var.aws_region)}"

  subnet_id = "${aws_subnet.public-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.ethereum.id}"]
  key_name = "${var.keyname}"

  associate_public_ip_address = true

  connection {
    user = "ubuntu"
  }

  # This will create 1 instance
  count = 1

  tags {
    Name = "ethereum node"
  }
}

terraform {
  backend "s3" {
    bucket = "joewww-gitlab-terraform"
    key    = "state.tfstate"
    region = "us-east-1"
  }
}


# Volume management
resource "aws_volume_attachment" "ebs_ethereum_data" {
  device_name = "/dev/sdf"
  volume_id   = "vol-0d35fe7aac66dfae8"
  instance_id = "${aws_instance.ethereum.id}"
}

# resource "aws_ebs_volume" "example" {
#   availability_zone = "us-east-1a"
#   size              = 1
# }


# Elastic IP
resource "aws_eip" "lb" {
  instance    = "${aws_instance.ethereum.id}"
  vpc         = true
  depends_on  = ["aws_internet_gateway.gw"]
}


# Define our VPC
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "ethereum-vpc"
  }
}

# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet_cidr}"
  availability_zone = "us-east-1a"

  tags {
    Name = "ethereum public subnet"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "ethereum VPC IGW"
  }
}

# Define the route table
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}


# Define the security group for public subnet
resource "aws_security_group" "ethereum" {
  name = "ethereum node"
  description = "SSH, RPC, geth access"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["${var.me}"]
    description = "SSH for myself"
  }

# RPC Client
  ingress {
    from_port = 8545
    to_port = 8545
    protocol = "tcp"
    cidr_blocks =  ["${var.me}"]
    description = "RPC for myself"
  }

# Ethereum client
  ingress {
    from_port = 30303
    to_port = 30303
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
    description = "geth client"
  }
  ingress {
    from_port = 30303
    to_port = 30303
    protocol = "udp"
    cidr_blocks =  ["0.0.0.0/0"]
    description = "geth client"
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "outbound access"
}

  vpc_id="${aws_vpc.default.id}"

  tags {
    Name = "ethereum security group"
  }
}
