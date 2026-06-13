# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "heimdall-igw" }
}

# Elastic IP para el NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

# NAT Gateway (Ahora ubicado en la Subred PÚBLICA)
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags          = { Name = "heimdall-nat" }
  
  # Asegura que el IGW esté creado antes que el NAT
  depends_on = [aws_internet_gateway.main]
}

# Public Route Table (Para que el NAT Gateway pueda salir a internet)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = { Name = "heimdall-public-rt" }
}

# Asociación de subred pública
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table (hacia el NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = { Name = "heimdall-private-rt" }
}

# Asociar subredes privadas
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
