resource "yandex_compute_instance" "rest-api-vm1" {
	name = "rest-api-vm1"
	platform_id = "standard-v3"
	zone = "${var.av_zone}"
	
	resources {
		cores = "2"
		memory = "2"
	}

	boot_disk {
		disk_id = yandex_compute_disk.boot-disk-vm1.id
	}

	network_interface {
		subnet_id = "e2l0882cjfj2agu86md5"
		nat = true
	}

	metadata = {
		fqdn = "rest-api-vm1.${var.service_dns_zone}"
		user-data = "#cloud-config\nusers:\n  - name: waliko\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("~/.ssh/id_rsa.pub")}"
	}
}
