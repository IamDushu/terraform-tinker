provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
  source            = "./modules/subnet"
  vpc_id            = aws_vpc.myapp-vpc.id
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone        = var.avail_zone
  env_prefix        = var.env_prefix
}

module "myapp-webserver" {
  source              = "./modules/webserver"
  vpc_id              = aws_vpc.myapp-vpc.id
  avail_zone          = var.avail_zone
  env_prefix          = var.env_prefix
  my_ip               = var.my_ip
  ami_id              = var.ami_id
  subnet_id           = module.myapp-subnet.subnet.id
  instance_type       = var.instance_type
  public_key_location = var.public_key_location
}
