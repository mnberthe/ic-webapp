data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "ec2" {
  count                  = var.instance_count
  instance_type          = var.instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.key.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.public_subnet[count.index].id
  root_block_device {
    volume_size = var.vol_size
  }

  tags = {
    Name = "ec2-instance-${count.index + 1}"
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tftpl", {
    odoo_ipv4  = "${aws_instance.ec2[1].public_ip}"
    ic_webapp_server_ipv4 ="${aws_instance.ec2[2].public_ip}"
    pg_admin_server_ipv4 ="${aws_instance.ec2[2].public_ip}"
  })
  filename = "../ansible/inventory"
}

output "instance_ips" {
  value = [for i in aws_instance.ec2[*]: i.public_ip]
}

output "instance_ids" {
  value = [for i in aws_instance.ec2[*]: i.id]
}