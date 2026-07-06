output "cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.this.id
}

output "service_name" {
  description = "ECS Service Name"
  value       = aws_ecs_service.this.name
}