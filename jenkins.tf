resource "openstack_compute_floatingip_v2" "jenkins_floatingip" {
  depends_on = ["openstack_networking_router_interface_v2.router_interface"]
  region = "${var.region}"
  pool = "${var.floating_pool}"
}

# Template for jenkins installation
data "template_file" "jenkins_postinstall_script" {
  template = "${file("jenkins.tpl")}"
  vars {
    redmine_ip = "${openstack_compute_floatingip_v2.redmine_floatingip.address}"
    redmine_version = "${var.redmine_version}"
  }
}

resource "openstack_compute_instance_v2" "jenkins" {
  name = "jenkins"
  region = "${var.region}"
  image_name = "${var.image}"
  flavor_name = "${var.flavor}"
  security_groups = [ "${openstack_compute_secgroup_v2.secgroup.name}" ]
  floating_ip = "${openstack_compute_floatingip_v2.jenkins_floatingip.address}"
  user_data = "${data.template_file.jenkins_postinstall_script.rendered}"

  network {
    uuid = "${openstack_networking_network_v2.private_network.id}"
  }
}
