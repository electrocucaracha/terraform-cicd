resource "openstack_compute_floatingip_v2" "redmine_floatingip" {
  depends_on = ["openstack_networking_router_interface_v2.router_interface"]
  region = "${var.region}"
  pool = "${var.floating_pool}"
}

# Template for redmine installation
data "template_file" "redmine_postinstall_script" {
  template = "${file("redmine.tpl")}"
  vars {
    version = "${var.redmine_version}"
  }
}

resource "openstack_compute_instance_v2" "redmine" {
  name = "redmine"
  region = "${var.region}"
  image_name = "${var.image}"
  flavor_name = "${var.flavor}"
  security_groups = [ "${openstack_compute_secgroup_v2.secgroup.name}" ]
  floating_ip = "${openstack_compute_floatingip_v2.redmine_floatingip.address}"
  user_data = "${data.template_file.redmine_postinstall_script.rendered}"

  network {
    uuid = "${openstack_networking_network_v2.private_network.id}"
  }
}
