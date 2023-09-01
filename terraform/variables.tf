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

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "vol_size" {
  type    = number
  default = 8
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "key_name" {
  type = string
}


variable "public_key_path" {
  type = string
}