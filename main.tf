

locals {
  this_pcx  = "${data.aws_vpc_peering_connection.this.id}"
  peer_cidr = "${var.peer_env["cidr"]}"
}


data "aws_vpc_peering_connection" "this" {

  vpc_id      = "${var.peer_env["vpc"]}"
  peer_vpc_id = "${var.this_env["vpc"]}"

  filter {
    name = "status-code"
    values = [ "active" ]
  }
}

resource "aws_route" "pub_gateway" {
  route_table_id            = "${var.pub_route_table}"
  vpc_peering_connection_id = "${local.this_pcx}"
  destination_cidr_block    = "${local.peer_cidr}"
}

resource "aws_route" "priv_gateways" {
  count = "${length(var.priv_route_tables)}"

  route_table_id            = "${element(var.priv_route_tables, count.index)}"
  vpc_peering_connection_id = "${local.this_pcx}"
  destination_cidr_block    = "${local.peer_cidr}"
}



