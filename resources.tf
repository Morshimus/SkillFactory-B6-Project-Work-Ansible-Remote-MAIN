resource "yandex_vpc_network" "morsh-network" {
  name = var.network_name_yandex

}


resource "yandex_vpc_subnet" "morsh-subnet-a" {
  name           = var.subnet_a_name_yandex
  description    = var.subnet_a_description_yandex
  v4_cidr_blocks = var.subnet_a_v4_cidr_blocks_yandex
  zone           = var.zone_yandex_a
  network_id     = yandex_vpc_network.morsh-network.id

}


#resource "yandex_vpc_subnet" "morsh-subnet-b" {
#  name           = var.subnet_b_name_yandex
#  description    = var.subnet_b_description_yandex
#  v4_cidr_blocks = var.subnet_b_v4_cidr_blocks_yandex
#  zone           = var.zone_yandex_b
#  network_id     = yandex_vpc_network.morsh-network.id

#}


module "morsh_instance_ya_1" {
  source               = "./INSTANCE"
  source_image         = var.source_image_2
  vpc_subnet_id        = yandex_vpc_subnet.morsh-subnet-a.id
  creation_zone_yandex = var.zone_yandex_a
  os_disk_size         = var.os_disk_size
  os_disk_type         = "network-hdd"
  prefix               = "db-web"
}


module "morsh_instance_ya_2" {
  source               = "./INSTANCE"
  source_image         = var.source_image_2
  vpc_subnet_id        = yandex_vpc_subnet.morsh-subnet-a.id
  creation_zone_yandex = var.zone_yandex_a
  os_disk_size         = var.os_disk_size
  os_disk_type         = "network-hdd"
  prefix               = "app1"
}


module "morsh_instance_ya_3" {
  source               = "./INSTANCE"
  source_image         = var.source_image_1
  vpc_subnet_id        = yandex_vpc_subnet.morsh-subnet-a.id
  creation_zone_yandex = var.zone_yandex_a
  os_disk_size         = var.os_disk_size
  os_disk_type         = "network-hdd"
  prefix               = "app2"
}



resource "local_file" "yc_inventory" {
  content  = local.ansible_template
  filename = "${path.module}/yandex_cloud.ini"
}

resource "local_file" "yc_inventory_remote" {
  content  = local.ansible_template_remote
  filename = "${path.module}/roles/common/ansible/files/inventory.ini"

  provisioner "local-exec" {
    command     = "Wait-Event -Timeout 60;. ./actions.ps1;ansible-playbook -secret"
    interpreter = ["powershell.exe", "-NoProfile", "-c"]
  }

  provisioner "remote-exec" {
    inline = ["sudo ansible-playbook  --ssh-common-args '-o StrictHostKeyChecking=no' -i inventory.ini --private-key ./morsh_ansible_SSH   provisioning.yaml "]

    connection {
      host        = module.morsh_instance_ya_1.external_ip_address_morsh_bastion
      type        = "ssh"
      user        = "ansible"
      private_key = file("./morsh_ansible_SSH")
    }
  }
}

