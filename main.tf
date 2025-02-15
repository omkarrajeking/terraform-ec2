resource "aws_vpc" "RestAPI"{
    cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
     vpc_id = aws_vpc.RestAPI.id
     cidr_block = "10.0.0.0/24"
     availability_zone = "ap-south-1a"
     map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
     vpc_id = aws_vpc.RestAPI.id
     cidr_block = "10.0.1.0/24"
     availability_zone = "ap-south-1b"
     map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "RestAPI_igw"{
    vpc_id = aws_vpc.RestAPI.id
}

resource "aws_route_table" "aws_r1" {
  vpc_id = aws_vpc.RestAPI.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.RestAPI_igw.id
  }
}

resource "aws_route_table_association" "aws_r1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.aws_r1.id
}

resource "aws_route_table_association" "aws_r2" {
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.aws_r1.id      
  
}

resource "aws_security_group" "RestAPI_sg" {
  vpc_id = aws_vpc.RestAPI.id
  name = "RestAPI_name_sg"
  description = "Allow inbound traffic"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }   
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }     
  tags = {
    Name = "RestAPI_tag_sg"
  }
}   

resource "aws_s3_bucket" "example" {
  bucket = "omkarbucket123456789"
}



resource "aws_instance" "RestAPI_webserver" {
  ami = "ami-00bb6a80f01f03502"
  instance_type = "t2.micro"
  
  vpc_security_group_ids = [aws_security_group.RestAPI_sg.id]
  subnet_id = aws_subnet.sub1.id
  user_data = base64encode(file("userdata.sh"))

}

resource "aws_instance" "RestAPI_webserver2" {
  ami = "ami-00bb6a80f01f03502"
  instance_type = "t2.micro"
  
  vpc_security_group_ids = [aws_security_group.RestAPI_sg.id]
  subnet_id = aws_subnet.sub2.id
  user_data = base64encode(file("userdata1.sh"))
  
}

resource "aws_alb" "name" {
  name = "RestAPI-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.RestAPI_sg.id]
  subnets = [aws_subnet.sub1.id, aws_subnet.sub2.id]
  tags = {
    Name = "RestAPI-alb"
  }
  
}

resource "aws_lb_target_group" "tg" {
   name = "RestAPI-tg"
   port = 80
   protocol = "HTTP"
   vpc_id = aws_vpc.RestAPI.id
   target_type = "instance"
  health_check {
     path = "/"
      protocol = "HTTP"
      port = "traffic-port"
      interval = 30
      timeout = 5
      healthy_threshold = 2
      unhealthy_threshold = 2  
    }  
}

resource "aws_lb_target_group_attachment" "attach1" {
     target_group_arn = aws_lb_target_group.tg.arn
      target_id = aws_instance.RestAPI_webserver.id
      port = 80

}

resource "aws_lb_target_group_attachment" "attach2" {
     target_group_arn = aws_lb_target_group.tg.arn
      target_id = aws_instance.RestAPI_webserver2.id
      port = 80
      
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.name.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

output "load_balancer_dns" {
  value = aws_alb.name.dns_name
}