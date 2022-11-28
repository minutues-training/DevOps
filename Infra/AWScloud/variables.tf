variable "REGION" {
  default = "us-east-2"
}

variable "subnets" {
  type    = number
  default = 6


}

variable "ZONE1" {
  default = "us-east-2a"
}

variable "ZONE2" {
  default = "us-east-2b"
}

variable "ZONE3" {
  default = "us-east-2c"
}


variable "AMIS" {
  type = map(any)
  default = {
    us-east-2 = "ami-092b43193629811af"
    us-west-1 = "ami-09208e69ff3feb1db"
  }
}

variable "USER" {
  default = "ec2-user"
}

variable "PUB_KEY" {
  default = "projectplan.pub"
}

variable "PRIV_KEY" {
  default = "projectplan.pub"
}

variable "MYIP" {
  default = "0.0.0.0/0"
  #default = "10.0.0.0./16"
}

variable "project-vm" {
  type    = number
  default = 6
}

variable "type" {
  default = "t2.micro"
}




