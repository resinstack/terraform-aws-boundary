output "controller_worker_address" {
  value       = aws_lb.boundary.dns_name
  description = "Address of the NLB for workers to contact controllers"
}

output "worker_external_address" {
  value       = aws_lb.boundary.dns_name
  description = "Address of the NLB for client to contact workers"
}

output "controller_sg_id" {
  value       = aws_security_group.controller.id
  description = "Security group ID for controllers"
}

output "worker_sg_id" {
  value       = aws_security_group.worker.id
  description = "Security group ID for workers"
}

output "kms" {
  value       = { for id, kms in aws_kms_key.key : id => kms.key_id }
  description = "KMS key IDs"
}

output "postgres_secret_name" {
  value       = aws_secretsmanager_secret.postgres_url.name
  description = "Name of the postgresql secrets URL"
}

output "controller_target_group_arn" {
  value       = aws_lb_target_group.controller_external.arn
  description = "ARN of the client facing target group"
}
