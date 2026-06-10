# Internet Gateway (opcional si ya no usas subnets públicas)
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "heimdall-igw" }
}

# Elastic IP para el NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

# NAT Gateway (Necesitas asegurar que apunte a una subnet válida, 
# si la pública no existe, asegúrate de tener una subnet pública definida o usa una privada)
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.private[0].id # Apuntamos a la privada si la pública no existe
  tags          = { Name = "heimdall-nat" }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = { Name = "heimdall-private-rt" }
}

# Associate private subnets
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
