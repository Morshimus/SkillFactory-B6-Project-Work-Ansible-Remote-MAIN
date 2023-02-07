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
* В заданиях описан концепт создания удаленной среды ansible, с помощью плейбуков и ролей. Мной было решено сделать все выполенения задания из терраформ - посредством ресурса local_file(Динамическая инвентаризация),local-exec(Запуск плейбука для преднастройки удаленых машин), remote-exec (Удаленный запуск ansible с плейбуком).*

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
$${\color{magenta}resources.tf:}$$
```
resource "local_file" "yc_inventory_remote" {
  content  = local.ansible_template_remote
  filename = "${path.module}/roles/common/ansible/files/inventory.ini"
  }

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
