output "vpc_id" {
  value = aws_vpc.vpc_1.id
}


# BE SN
output "sn_1_id" {
  value = aws_subnet.sn_1.id

}


# WEB SN
output "sn_2_id" {
  value = aws_subnet.sn_2.id

}

output "sn_3_id" {
  value = aws_subnet.sn_3.id

}

output "sn_4_id" {
  value = aws_subnet.sn_4.id

}


output "gw_1_id" {
  value = aws_internet_gateway.gw_1.id
}

output "rt_1_id" {
  value = aws_route_table.rt_1.id
}
