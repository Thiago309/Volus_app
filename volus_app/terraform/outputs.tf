
output "instance_public_ip" {
  description = "IP Público da instância EC2 provisionada na AWS"
  value       = aws_instance.server.public_ip
}

output "app_url" {
  description = "URL para acessar o aplicativo Flutter Web"
  value       = "http://${aws_instance.server.public_ip}"
}

output "jenkins_url" {
  description = "URL para acessar o painel de CI/CD do Jenkins"
  value       = "http://${aws_instance.server.public_ip}:8080"
}

output "grafana_url" {
  description = "URL para acessar o painel de monitoramento do Grafana"
  value       = "http://${aws_instance.server.public_ip}:3000"
}

output "prometheus_url" {
  description = "URL para acessar o console do Prometheus"
  value       = "http://${aws_instance.server.public_ip}:9090"
}
