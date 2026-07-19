variable "aws_region" {
  description = "Região da AWS para provisionamento dos recursos"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo de instância EC2 para suportar a stack de monitoramento e Jenkins"
  type        = string
  default     = "t3.medium" # Recomenda-se pelo menos 4GB de RAM para Jenkins + Prometheus + Grafana + App
}

variable "ami_id" {
  description = "ID da AMI Ubuntu Server 22.04 LTS na us-east-1"
  type        = string
  default     = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS na us-east-1
}

variable "key_name" {
  description = "Nome da chave SSH previamente criada na AWS"
  type        = string
  default     = "voluts-teto-ssh-key"
}

variable "project_name" {
  description = "Nome do projeto para identificação de recursos"
  type        = string
  default     = "voluts-teto"
}
