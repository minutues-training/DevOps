resource "aws_key_pair" "project" {
  key_name   = "projectplan"
  public_key = file("projectplan.pub")
}

resource "aws_instance" "project-machine" {
  count                  = var.project-vm
  ami                    = var.AMIS[var.REGION]
  instance_type          = var.type
  subnet_id              = aws_subnet.subnets[count.index].id
  key_name               = aws_key_pair.project.key_name
  vpc_security_group_ids = [aws_security_group.project-sg.id]
  availability_zone      = var.ZONE1
  tags = {
    Name = "DevOps${count.index}"
    #for_each = toset(["jenkins","nexus","zabbix","sonar","elk","apache"])
    #Name                  = each.key
  }
}

resource "aws_instance" "apache" {

  ami                    = var.AMIS[var.REGION]
  instance_type          = var.type
  subnet_id              = aws_subnet.public.id
  key_name               = aws_key_pair.project.key_name
  vpc_security_group_ids = [aws_security_group.project-sg.id]
  availability_zone      = var.ZONE1
  tags = {
    Name = "Apache"

  }
}


resource "aws_ebs_volume" "extra-disk" {
  availability_zone = var.ZONE1
  size              = 40

  tags = {
    Name = "extra-volume"
  }
}

resource "aws_volume_attachment" "attach-volume" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.extra-disk.id
  instance_id = aws_instance.project-machine[2].id
  depends_on = [
    aws_instance.project-machine[2]
  ]

}

