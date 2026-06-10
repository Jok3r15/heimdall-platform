# Declare the data source to fetch available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 2)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  
  # Explicitly set to false to ensure no public IPs are assigned
  # This satisfies CKV_AWS_130
  map_public_ip_on_launch = false 

  tags = { 
    Name = "heimdall-private-${count.index}" 
  }
}
