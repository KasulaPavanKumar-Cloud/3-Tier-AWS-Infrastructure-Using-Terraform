output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_ids" { value = [for s in aws_subnet.public : s.id] }
output "private_app_subnet_ids" { value = [for s in aws_subnet.private_app : s.id] }
output "private_db_subnet_ids" { value = [for s in aws_subnet.private_db : s.id] }
output "nat_gateway_id" { value = aws_nat_gateway.nat.id }
output "vpc_cidr_block" { value = aws_vpc.this.cidr_block }