resource "openstack_networking_network_v2" "private_network" {
  name = "cicd-private"
  region = "${var.region}"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "private_subnet01" {
  name = "cicd-subnet"
  region = "${var.region}"
  network_id = "${openstack_networking_network_v2.private_network.id}"
  cidr = "192.168.50.0/24"
  ip_version = 4
  enable_dhcp = "true"
  dns_nameservers = ["8.8.8.8"]
}

resource "openstack_compute_secgroup_v2" "secgroup" {
  name = "cicd-secgroup"
  region = "${var.region}"
  description = "Security group for accessing to CI/CD environment"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_networking_router_v2" "router" {
  name = "cicd-router"
  region = "${var.region}"
  admin_state_up = "true"
  external_gateway = "${var.external_gateway}"
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  region = "${var.region}"
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.private_subnet01.id}"
}

resource "openstack_compute_floatingip_v2" "floatingip" {
  depends_on = ["openstack_networking_router_interface_v2.router_interface"]
  region = "${var.region}"
  pool = "${var.floating_pool}"
}
