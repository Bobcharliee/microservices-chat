output "vpc_id" {
  value = aws_vpc.microservices-vpc.id
}

output "pub_subnet_1a_id" {
  value = aws_subnet.ms-public-subnet-1a.id
}

output "pub_subnet_2a_id" {
  value = aws_subnet.ms-public-subnet-2a.id
}

output "priv_subnet_1a_id" {
  value = aws_subnet.ms-private-subnet-1a.id
}

output "priv_subnet_1b_id" {
  value = aws_subnet.ms-private-subnet-1b.id
}

output "priv_subnet_2a_id" {
  value = aws_subnet.ms-private-subnet-2a.id
}

output "priv_subnet_2b_id" {
  value = aws_subnet.ms-private-subnet-2b.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.ms-internet-gateway.id
}

