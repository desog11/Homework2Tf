variable "owner" {
    type = string
    default = "diego"
}

variable "vpc_cidr" {
    type = string
}

variable "public_rt_cidr"{
    type = string
    default = "0.0.0.0/0"
}

variable "public" {
    type = bool
    default = true
}

variable "no_subnets" {
  default = "6"
}