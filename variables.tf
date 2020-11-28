variable "lp" {
  description = "Name of licensePlate"
  type        = string
}

variable "cluster_name" {
  description = "Name of OpenShift cluster (klab, clab, silver, etc.)"
  type        = list(string)
  default     = [""]
}
