variable "instance_type" {
    type = string
    #default = "t2.micro"
}

variable "vpc_id" {
}

variable "sg_ingress_rules"{
    type = list(map(any))
    default     = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0"
        },
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_block  = "0.0.0.0/0"
        },
        {
          from_port   = 1
          to_port     = 1
          protocol    = "icmp"
          cidr_block  = "0.0.0.0/0"
        }
    ]
}

variable "ami" {
  type = string
  default = "ami-0b0ea68c435eb488d"
}

variable "name" {
    type = string
    default = "diego"
}

variable "sgname" {
    type = string
    default = "hw2-security-group"
}

variable "sgdescription"{
    type = string
    default = "Allow TLS inbound traffic"
}