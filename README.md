# SkillFactory-B6-Project-Work-Ansible-Remote-MAIN

# [Roles Here](https://github.com/Morshimus/SkillFactory-B6-Project-Work-Ansible-Remote-Roles)

## Задание Проектной Работы:
* [x] - :one: ~~**Создать 3 ВМ в Я.Облаке (минимальная конфигурация: 2vCPU, 2GB RAM, 20 GB HDD): vm1 и vm2 (Ubuntu 20.04), vm3 (Centos 8).**~~

* [x] - :two: ~~**Установить на vm1 Ansible.**~~

* [x] - :three: ~~**Создать на vm1 пользователя для Ansible.**~~

* [x] - :four: ~~**Настроить авторизацию по ключу для этого пользователя с vm1 на vm2 и vm3.**~~

* [x] - :five: ~~**Добавить в inventory информацию о созданных машинах. vm2 и vm3 должны быть в группе app, vm1 — в группе database и web.**~~

* [x] - :six: ~~**Написать плейбук, реализующий следующее:**~~
   - ~~*на машинах группы app выполняется установка и запуск Docker*~~
       - ~~*на машинах группы database выполняется установка и запуск postgresql-server (версия и data-директория должны быть переменными, задающимися в inventory).*~~

* [x] - :seven: ~~**Протестировать написанный плейбук.**~~

* [x] - :eight: ~~**Выложить плейбук и inventory в GitHub. Создайте отдельный репозиторий Ansible.**~~

* [x] - :nine: ~~**Прислать ментору ссылку на репозиторий с плейбуком.**~~

## Начало
- *В заданиях описан концепт создания удаленной среды ansible, с помощью плейбуков и ролей. Мной было решено сделать все выполенения задания из терраформ - посредством ресурса local_file(Динамическая инвентаризация),local-exec(Запуск плейбука для преднастройки удаленых машин), remote-exec (Удаленный запуск ansible с плейбуком).*

$${\color{magenta}locals.tf:}$$
```
  ansible_template_remote = templatefile(
    "${path.module}/templates/ansible_inventory_template_remote.tpl",
    {
      ip1       = module.morsh_instance_ya_1.internal_ip_address_morsh_bastion,
      hostname1 = module.morsh_instance_ya_1.hostname_morsh_bastion,
      ip2       = module.morsh_instance_ya_2.internal_ip_address_morsh_bastion,
      hostname2 = module.morsh_instance_ya_2.hostname_morsh_bastion
      ip3       = module.morsh_instance_ya_3.internal_ip_address_morsh_bastion,
      hostname3 = module.morsh_instance_ya_3.hostname_morsh_bastion


    }
  )

```
$${\color{magenta}resources.tf|local_file:}$$
```
resource "local_file" "yc_inventory_remote" {
  content  = local.ansible_template_remote
  filename = "${path.module}/roles/common/ansible/files/inventory.ini"
...

```

$${\color{yellow}templates|ansibleinventorytemplateremote.tpl:}$$

```
[database]
${hostname1} ansible_host=${ip1} ansible_user=ansible
[web]
${hostname1} ansible_host=${ip1} ansible_user=ansible
[app]
${hostname2} ansible_host=${ip2} ansible_user=ansible
${hostname3} ansible_host=${ip3} ansible_user=ansible
[database:vars]
pg_version=15
pg_data_root=/opt/pg_data

```

$${\color{magenta}resources.tf|local-exec+remote-exec:}$$

```
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
```

$${\color{pink}Let's \space Pimp \space Out \space Ride}$$
## Man, we decided to put your ansible-playbook inside ansible-playbook...
![image](https://github.com/Morshimus/SkillFactory-B6-Project-Work-Ansible-Remote-MAIN/blob/main/img/xzibit-pimp.gif)

# Скриншоты динамической  инвентаризации  и тестов разных систем в молекула:

> Для postgresql было протестирована установка дистров от 11 до 15. Для 15 создан отдельный теплейт j2, где закомментирован путь до stats_temp_directory, так как не используется в версии 15.
![image](https://db3pap003files.storage.live.com/y4mO-yloxGxwXyXyb8aSq0fzKvXx1YacHlOgMhOsswe4ewVRDQe-Lx6C4N0HlCk8xMzlrVijkCEk-gl1KX95n8_gASL-HcMjI93a6o0DChsPOqDeIY3D5xX7GCQz8klHqDXl_JR6MzCOl1ZDArWpMniN51n5oB6qKQCDygWaLIfqwzE1yfXvoCosQ4AvzZ5THT4NoALO99uRXBjnqUImTUJ0g/Project-B6-Handy-Tests-Molecule.jpg?psid=1&width=1537&height=777)

> Для тестирования установки докера - использовались тесты на двух платформах Ubuntu20.04 и CentOS7
![image](https://db3pap003files.storage.live.com/y4mPkRXEfnp-fXlg8Kcc-7ljoZS1rHvOSEtf2Kexkfv03mVDLjRaf5xN-_-NmN-N6N5RXL-YlOpIKTCdSFfoWZ7sS3_sGCS_tJCFM00zpR3Cz3W-aS9kwBgTX_zb8Z28u_wpc-HBDRxX5SZpgOa4PJSA1uV4z717EJ8NXfl72kBzbXqz4qTMXbnwQKxBEd0tF7ZPTwh4GJq6utZXyCoESG35A/Project-B6-Testing-Seperate-OS-Containers-Molecule.jpg?psid=1&width=1307&height=731)

> Динамическая инвентаризация которая создается терраформом, после создания ресурсов
![image](https://db3pap003files.storage.live.com/y4mEoJhHlM2nUzbuPi5x8gzlAGt6KQcnCu0FKobejJ8e4cBW4avKuf1pK-yAzRc5pUJD6bfHNTKWzOVlOPfK47WTuUC_4gSOFy7Ld2Gcx7NEc0MQJfajJ7RwiKoo3k2yZ-qIzlPXS-DF9qaPVMLfXX3dDkHgyTQ_STFcnMc-Q07RXhYlF9YpdHlA54LJZVafgUtn92JsSsgbB2L2Ot5ot6t8A/Project-B6-Inventory-File-For-Remote.jpg?psid=1&width=957&height=263)


# Скриншоты выполнения нашего Ansible + Remote Ansible:

> Start
![image](https://db3pap003files.storage.live.com/y4mECfLScJiMiJ6Ufru3mFa8UKdiYhENeSkBrsPbw7sSSY5oySXRojYn62Uj4E-L9TohijetNMSIRCWkSxCg1ZzNApZLoYQ6UJ9mZecWSZH71bOc4m34aCWPU53X9j7e_0wpc2sGDdlaUEuxFuIzOaTlUyg5LxzilLI_9MXT4w5jqJVFwR0GZvNfisTy5CjlmYrtQ1b1Xr8HifNuzmRMedrBA/Project-B6-1.jpg?psid=1&width=1667&height=802) ![image](https://db3pap003files.storage.live.com/y4mrKXkawKY2lui7yH3tbmCe1O9EQiQGnVW8bKgYhRQS9Zg9e5GzVtb8xn5W4FXDgzRmQg-7fI8P7wnAbDrAVSVhM0AkT9wrIliX7A6p-nz51-9BPM6qj2gBW0fz-v83PzytjiWSoYp_1Ad8W_Ti8Hz9HGP654oP7kBDNrAkTgqKlMOoAzQ5Qf-vBGcnQxEptiWv6wfQ5lIjPplr_QcsOscdg/Project-B6-2.jpg?psid=1&width=1632&height=802) ![image](https://db3pap003files.storage.live.com/y4mEy_yTs39eKRc8C6RBDyo1Yf4VylNnMAShyplJlJw71DAeml8TTVjRMJnNFGiMW-Kk-6ly2-U84_zvL_Lnjy8YyuYHjmC2k_ox4dngmWIGXiNyj7Hxw7DXJtIV4swHQJRdAdTR09tJ1wZxYHP5oxpYjwAGZ7yBo9y2vVLNqYNxK1Pbkq3bWjaVMqvkoLN8eyJYB1Vak9CbUhAAG5qF0mmAQ/Project-B6-3.jpg?psid=1&width=1599&height=802) ![image](https://db3pap003files.storage.live.com/y4mgcFw0euimJmvOIDgkgPZzrS-_gQd5_7VSi3yxK39-Kk5kSXsYQQywu90UlC4j7xRxUEgCSqH-yLIIspb683TwfDPdPbu4wXSkil0Md2DDyhvpzJBwAcf3aiicxOUp37X03RF3zAnbnuDLZuSqxZTvT6Eu4HP2Pkb_fZe8j_bUBfGMnbCgx2cG8TBhxy5aqHe9OI-GVpAAj9DGLvIa-9Jxg/Project-B6-4.jpg?psid=1&width=1558&height=802) ![image](https://db3pap003files.storage.live.com/y4mvm2MKBtIQCbg7YySCLI5UoP623It0TStnUuWEYDdl-u8VAxN-qwS6GsHI4WvOhoyvNb_6wiHKrZl0EhAD4UyqR3mSLWlNedo2eeGUeotYMHL1srmkS45p9FHDjUFvXcivjeLXtUASeKICR_2gB-6UrFdknCIZ7QPDaoyPErfNLy_MwWV0ORypV-NTzc6d3AVn8UKqFp4Tkqr0xJZ5kw8Sw/Project-B6-5.jpg?psid=1&width=1545&height=802) ![image](https://db3pap003files.storage.live.com/y4mgNf4kdU5i3rh84PAg_Ygg-PhhQxH3i3dRWZ4B_EmbkOJI33XYvAvmw8yaZf5rpeeoUv5rcAmYKSRX4myWlAeoO4soO7jE7RzqzUMHXC7dO3ZLnSIQicojcxhEhsvUhnSUdwhUfgPcUjsCB6fgKTEiRP_kzl7KAe4EFfUBz7zl3iEov82LC9khBQeo3c48RRPofa2S6tKUBxTwMU6jGJk7g/Project-B6-6.jpg?psid=1&width=1583&height=802) Далее делал отдельный пробег, ибо powershell поломал вывод в консоль ![image](https://db3pap003files.storage.live.com/y4m0ZhzadQ1TmxhaqEXNO68CNTsFkz35nk3pVOLSYd-Y5OZr13YFK7cMyXaRSgFs7zxTjCSY9_47eamd68baWVehvJVqKa8_kn4XG63iPWaA_herRs0_ws72Ep5CIri5Ffk3CnbM6lzsgA4ti86RLq0tBsYBAeUGr72bvCpXRvAOEpQ_o94sugbshZr2Ngz2Osd7uqi6KmYnajU4hx3qtNaRQ/Project-B6-7.jpg?psid=1&width=1498&height=802)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.5 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.3.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | ~> 0.84.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.3.0 |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.84.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_morsh_instance_ya_1"></a> [morsh\_instance\_ya\_1](#module\_morsh\_instance\_ya\_1) | ./INSTANCE | n/a |
| <a name="module_morsh_instance_ya_2"></a> [morsh\_instance\_ya\_2](#module\_morsh\_instance\_ya\_2) | ./INSTANCE | n/a |
| <a name="module_morsh_instance_ya_3"></a> [morsh\_instance\_ya\_3](#module\_morsh\_instance\_ya\_3) | ./INSTANCE | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.yc_inventory](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.yc_inventory_remote](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [yandex_vpc_network.morsh-network](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.morsh-subnet-a](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_id_yandex"></a> [cloud\_id\_yandex](#input\_cloud\_id\_yandex) | Cloud id of yandex.cloud provider | `string` | n/a | yes |
| <a name="input_folder_id_yandex"></a> [folder\_id\_yandex](#input\_folder\_id\_yandex) | Folder id of yandex.cloud provider | `string` | n/a | yes |
| <a name="input_network_name_yandex"></a> [network\_name\_yandex](#input\_network\_name\_yandex) | Created netowork in yandex.cloud name | `string` | n/a | yes |
| <a name="input_os_disk_size"></a> [os\_disk\_size](#input\_os\_disk\_size) | Size of required vm | `string` | `"20"` | no |
| <a name="input_service_account_key_yandex"></a> [service\_account\_key\_yandex](#input\_service\_account\_key\_yandex) | Local storing service key. Not in git tracking | `string` | `"./key.json"` | no |
| <a name="input_source_image_1"></a> [source\_image\_1](#input\_source\_image\_1) | OS family of image for group 1 | `string` | `"centos-stream-8"` | no |
| <a name="input_source_image_2"></a> [source\_image\_2](#input\_source\_image\_2) | OS family of image for group 2 | `string` | `"ubuntu-2004-lts"` | no |
| <a name="input_subnet_a_description_yandex"></a> [subnet\_a\_description\_yandex](#input\_subnet\_a\_description\_yandex) | n/a | `string` | `"Subnet A for morshimus instance A"` | no |
| <a name="input_subnet_a_name_yandex"></a> [subnet\_a\_name\_yandex](#input\_subnet\_a\_name\_yandex) | Subnet for 1st instance | `string` | `"morsh-subnet-a"` | no |
| <a name="input_subnet_a_v4_cidr_blocks_yandex"></a> [subnet\_a\_v4\_cidr\_blocks\_yandex](#input\_subnet\_a\_v4\_cidr\_blocks\_yandex) | IPv4 network for 1st instance subnet | `list(string)` | <pre>[<br>  "192.168.21.0/28"<br>]</pre> | no |
| <a name="input_useros_1"></a> [useros\_1](#input\_useros\_1) | OS native default user for group 1 | `string` | `"cloud-user"` | no |
| <a name="input_useros_2"></a> [useros\_2](#input\_useros\_2) | OS native default user for group 2 | `string` | `"ubuntu"` | no |
| <a name="input_zone_yandex_a"></a> [zone\_yandex\_a](#input\_zone\_yandex\_a) | Zone of 1st instance in yandex cloud | `string` | `"ru-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_ip_address_vm_1"></a> [external\_ip\_address\_vm\_1](#output\_external\_ip\_address\_vm\_1) | n/a |
| <a name="output_external_ip_address_vm_2"></a> [external\_ip\_address\_vm\_2](#output\_external\_ip\_address\_vm\_2) | n/a |
| <a name="output_external_ip_address_vm_3"></a> [external\_ip\_address\_vm\_3](#output\_external\_ip\_address\_vm\_3) | n/a |
| <a name="output_hostname_vm_1"></a> [hostname\_vm\_1](#output\_hostname\_vm\_1) | n/a |
| <a name="output_hostname_vm_2"></a> [hostname\_vm\_2](#output\_hostname\_vm\_2) | n/a |
| <a name="output_hostname_vm_3"></a> [hostname\_vm\_3](#output\_hostname\_vm\_3) | n/a |
| <a name="output_internal_ip_address_vm_1"></a> [internal\_ip\_address\_vm\_1](#output\_internal\_ip\_address\_vm\_1) | n/a |
| <a name="output_internal_ip_address_vm_2"></a> [internal\_ip\_address\_vm\_2](#output\_internal\_ip\_address\_vm\_2) | n/a |
| <a name="output_internal_ip_address_vm_3"></a> [internal\_ip\_address\_vm\_3](#output\_internal\_ip\_address\_vm\_3) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
