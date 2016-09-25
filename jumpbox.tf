data "template_file" "jumpbox_cloudinit" {
    template = "${file("jumpbox.tpl")}"
}

resource "openstack_compute_secgroup_v2" "jumpbox_secgroup" {
  name = "cicd-jumpbox"
  region = "${var.region}"
  description = "Security group for accessing jumpbox from outside"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 80
    to_port = 8880
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_compute_instance_v2" "jumpbox" {
  name = "cicd-jumbox"
  region = "${var.region}"
  image_name = "${var.image}"
  flavor_name = "${var.flavor}"
  security_groups = [ "${openstack_compute_secgroup_v2.jumpbox_secgroup.name}" ]
  floating_ip = "${openstack_compute_floatingip_v2.floatingip.address}"
  user_data = "${data.template_file.jumpbox_cloudinit.rendered}"

  network {
    uuid = "${openstack_networking_network_v2.private_network.id}"
  }

  provisioner "local-exec" {
    command = "echo \"ssh -o PreferredAuthentications=password -L 8880:192.168.50.$1:80 -t cicd@${openstack_compute_floatingip_v2.floatingip.address} ssh cicd@192.168.50.$1\" > ssh.sh"
  }
}
