variable "vpc_id" {
  type        = string
  description = "VPC that you wish to deploy into"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of IDs for subnets to deploy public resources into."
}

variable "cluster_tag" {
  type        = string
  description = "Tag to identify all resources in the cluster"
}

variable "source_sgs" {
  type        = map(string)
  description = "Map of source security groups and descriptions"
}

variable "client_sgs" {
  type        = map(list(string))
  description = "Map of client source locations for traffic"
}

variable "target_sgs" {
  type        = map(object({ port = number, group = string }))
  description = "Map of target security groups with descriptions and port numbers"
}

variable "common_sg" {
  type        = string
  description = "Common security group for all machines"
}

variable "database_sg" {
  type        = string
  description = "Security group that accepts traffic to the database"
}

variable "enable_key_rotation" {
  type        = bool
  description = "Enable rotation of the KMS keys"
  default     = true
}

variable "ssh_key_name" {
  type        = string
  description = "SSH Key to attach to hosts"
}

variable "controller_cfg" {
  type = object({
    ami      = string
    size     = string
    min      = number
    max      = number
    userdata = string
  })
  description = "Configuration data related to boundary controllers"
}

variable "worker_cfg" {
  type = object({
    ami      = string
    size     = string
    min      = number
    max      = number
    userdata = string
  })
  description = "Configuration data related to boundary workers"
}
