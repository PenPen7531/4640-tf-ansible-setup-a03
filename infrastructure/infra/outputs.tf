output "vpc_id" {
  value = module.vpc.vpc_id
}

output "sn_1" {
  value = module.vpc.sn_1_id

}

output "gw_1" {
  value = module.vpc.gw_1_id
}

output "rt_1" {
  value = module.vpc.rt_1_id
}

output "sg_1" {
  value = module.sg_be.sg_1_id
}

output "sg_2" {
  value = module.sg_web.sg_1_id
}

output "be_instance_id" {
  value = module.be.ec2_instance_id
}

output "be_instance_public_ip" {
  value = module.be.ec2_instance_public_ip
}

output "be_instance_public_dns" {
  value = module.be.ec2_instance_public_dns
}


output "web_instance_id" {
  value = module.web.ec2_instance_id
}

output "web_instance_public_ip" {
  value = module.web.ec2_instance_public_ip
}

output "web_instance_public_dns" {
  value = module.web.ec2_instance_public_dns
}
