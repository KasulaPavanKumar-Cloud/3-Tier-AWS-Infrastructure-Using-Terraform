#here we output the RDS instance endpoint and ID
output "db_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.this.id
}
