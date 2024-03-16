resource "aws_route_table" "default" {
  vpc_id = local.baas_shared_vpc_us.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = local.baas_shared_vpc_us.natgw_ids[0]
  }

  tags = module.naming.tags
}

resource "aws_route_table_association" "default" {
  for_each = { for k,v in module.subnets.private_subnet_ids : k => v }
  subnet_id      = each.value
  route_table_id = aws_route_table.default.id

  depends_on = [ aws_route_table.default, module.subnets ]
}