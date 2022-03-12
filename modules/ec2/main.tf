data "aws_subnet" "private_subnet" {
  vpc_id = var.vpc_id

    filter {
    name   = "tag:Name"
    values = ["hw2-private-subnet 5"]
  }

}

resource "aws_instance" "hw2-ec2" {

	ami = var.ami
	instance_type = var.instance_type
  subnet_id = data.aws_subnet.private_subnet.id

	tags = {
		Name = "EC2"
	}
	vpc_security_group_ids = [aws_security_group.hw2sg.id]
}

resource "aws_security_group" "hw2sg" {
	name = var.sgname
  description = var.sgdescription
  vpc_id      = var.vpc_id
  
	dynamic "ingress" {
    for_each = var.sg_ingress_rules
    content{
    from_port = ingress.value.from_port
		to_port = ingress.value.to_port
		protocol = ingress.value.protocol
		cidr_blocks = [ingress.value.cidr_block]
    }

	}
 
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}