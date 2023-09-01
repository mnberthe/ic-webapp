variable "vpc_cidr" {
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_cidrs" {
  type = list(string)
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "access_ip" {
  type    = string
  default = "86.206.242.52/32"
}

variable "jenkins_ip" {
  type    = string
  default = "15.188.105.8/32"
}
