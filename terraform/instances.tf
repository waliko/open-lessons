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
		user-data = "#cloud-config\nusers:\n  - name: toor\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("~/.ssh/id_ed25519.pub")}"
	}

  connection {
    host = "${self.network_interface.0.nat_ip_address}"
    type = "ssh"
    user = "toor"
    private_key = "${file("~/.ssh/id_ed25519")}"
  }

  provisioner "remote-exec" {
    script = "scripts/wait-vm.sh"
  }

  provisioner "local-exec" {
    command = "cd ../provision && ansible-playbook -i '${self.network_interface.0.nat_ip_address},' vm1.yml"
  }
}
