# Template for gerrit installation
data "template_file" "gerrit_postinstall_script" {
  template = "${file("gerrit.tpl")}"
  vars {
    password = "secure"
  }
}

resource "openstack_compute_secgroup_v2" "gerrit_secgroup" {
  name = "gerrit"
  region = "${var.region}"
  description = "Security group for accessing to Gerrit"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    from_group_id = "${openstack_compute_secgroup_v2.jumpbox_secgroup.id}"
  }
  rule {
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_compute_instance_v2" "gerrit" {
  name = "gerrit"
  region = "${var.region}"
  image_name = "${var.image}"
  flavor_name = "${var.flavor}"
  security_groups = [ "${openstack_compute_secgroup_v2.gerrit_secgroup.name}" ]
  user_data = "${data.template_file.gerrit_postinstall_script.rendered}"

  network {
    uuid = "${openstack_networking_network_v2.private_network.id}"
  }
}
