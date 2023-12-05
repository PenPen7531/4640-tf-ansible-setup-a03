module "vpc" {
  source       = "./modules/terraform_vpc_simple"
  project_name = var.project_name
  vpc_cidr     = "192.168.0.0/16"
  subnet_cidr1  = "192.168.1.0/24"
  subnet_cidr2  = "192.168.2.0/24"
  subnet_cidr3  = "192.168.3.0/24"
  subnet_cidr4  = "192.168.4.0/24"
  home_net     = "75.157.34.0/24"
  aws_region   = "us-west-2"
}

module "sg_be"{
  source = "./modules/terraform_security_group"
  sg_name = "be_sg"
  sg_description = "Allows ssh and internal ingress and all egress"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      description = "ssh access from home"
      ip_protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_ipv4 = "0.0.0.0/0"
      rule_name = "ssh_access_home"
    },
    {
      description = "ssh access from bcit"
      ip_protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_ipv4 = var.bcit_net
      rule_name = "ssh_access_bcit"
    },
    {
      description = "All traffic internal VPC"
      ip_protocol = "-1"
      from_port = -1
      to_port = -1
      cidr_ipv4 = "192.168.0.0/16"
      rule_name = "web_access_bcit"
    },
   ]
  egress_rules = [ 
    {
      description = "allow all egress traffic"
      ip_protocol = "-1"
      from_port = -1
      to_port = -1
      cidr_ipv4 = "0.0.0.0/0"
      rule_name = "allow_all_egress"
    }
   ]
}


module "sg_web"{
  source = "./modules/terraform_security_group"
  sg_name = "web_sg"
  sg_description = "Allows ssh and internal ingress and all egress"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      description = "ssh access from anywhere"
      ip_protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_ipv4 = "0.0.0.0/0"
      rule_name = "ssh_access_home"
    },
    {
      description = "ssh access from bcit"
      ip_protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_ipv4 = var.bcit_net
      rule_name = "ssh_access_bcit"
    },
    {
      description = "80 from anywhere"
      ip_protocol = "tcp"
      from_port = 80
      to_port = 80
      cidr_ipv4 = "0.0.0.0/0"
      rule_name = "80_ingress"
    },
    {
      description = "443 access to webpage"
      ip_protocol = "tcp"
      from_port = 443
      to_port = 443
      cidr_ipv4 = "0.0.0.0/0"
      rule_name = "443_access"
    },
    {
      description = "Backend Subnet Ingress"
      ip_protocol = "-1"
      from_port = -1
      to_port = -1
      cidr_ipv4 = "192.168.1.0/24"
      rule_name = "be_sub_ingress"
    },
   ]
  egress_rules = [ 
    {
      description = "allow all egress traffic"
      ip_protocol = "-1"
      from_port = -1
      to_port = -1
      cidr_ipv4 = "0.0.0.0/0"
      rule_name = "allow_all_egress"
    }
   ]
}


module "sg_rds"{
  source = "./modules/terraform_security_group"
  sg_name = "rds_sg"
  sg_description = "Allows ssh and internal ingress and all egress"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      description = "ingress_mysql"
      ip_protocol = "-1"
      from_port = -1
      to_port = -1
      cidr_ipv4 = "192.168.0.0/16"
      rule_name = "allow_sql_ingress"
    }
   ]
  egress_rules = [ 
    {
      description = "egress_mysql"
      ip_protocol = "-1"
      from_port = -1
      to_port = -1
      cidr_ipv4 = "192.168.0.0/16"
      rule_name = "allow_sql_egress"
    }
   ]
}


module "be" {
  source = "./modules/terraform_ec2_simple"
  project_name = var.project_name
  aws_region = var.aws_region
  ami_id = var.ami_id
  subnet_id = module.vpc.sn_1_id
  security_group_id = module.sg_be.sg_1_id
  ssh_key_name = var.ssh_key_name
  instance_name = "backend"
}


module "web" {
  source = "./modules/terraform_ec2_simple"
  project_name = var.project_name
  aws_region = var.aws_region
  ami_id = var.ami_id
  subnet_id = module.vpc.sn_2_id
  security_group_id = module.sg_web.sg_1_id
  ssh_key_name = var.ssh_key_name
  instance_name = "web"
}


module "rds"{
  source = "./modules/terraform_rds"
  subnets = [ module.vpc.sn_3_id, module.vpc.sn_4_id]
  sg = [module.sg_rds.sg_1_id]
}



resource "local_file" "inventory_file" {

  content = <<EOF
web:
  hosts:
    ${module.web.ec2_instance_public_dns}:

backend:
  hosts:
    ${module.be.ec2_instance_public_dns}:


EOF

  filename = "../../service/inventory/webservers.yml"

}



# https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
resource "local_file" "group_vars_file" {

  content = <<EOF


web_pub_ip: ${module.web.ec2_instance_public_ip}
backend_pub_ip: ${module.be.ec2_instance_public_ip}


web_pub_dns: ${module.web.ec2_instance_public_dns}
backend_pub_ip: ${module.be.ec2_instance_public_dns}


web_priv_ip: ${module.web.ec2_instance_private_ip}
backend_priv_ip: ${module.be.ec2_instance_private_ip}

database_endpoint: ${module.rds.host_address}


EOF

  filename = "../../service/group_vars/webservers.yml"

}



resource "local_file" "script_vars_file" {

  content = <<EOF

web_id="${module.web.ec2_instance_id}"
backend_id="${module.be.ec2_instance_id}"
web_dns="${module.web.ec2_instance_public_dns}"

EOF

  filename = "../../script_vars.sh"

}