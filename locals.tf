locals {

  ansible_template = templatefile(
    "${path.module}/templates/ansible_inventory_template.tpl",
    {
      user_type_1 = var.useros_1,
      user_type_2 = var.useros_2,
      ip1         = module.morsh_instance_ya_1.external_ip_address_morsh_bastion,
      hostname1   = module.morsh_instance_ya_1.hostname_morsh_bastion,
      ip2         = module.morsh_instance_ya_2.external_ip_address_morsh_bastion,
      hostname2   = module.morsh_instance_ya_2.hostname_morsh_bastion
      ip3         = module.morsh_instance_ya_3.external_ip_address_morsh_bastion,
      hostname3   = module.morsh_instance_ya_3.hostname_morsh_bastion


    }
  )

  ansible_template_remote = templatefile(
    "${path.module}/templates/ansible_inventory_template_remote.tpl",
    {
      ip1         = module.morsh_instance_ya_1.internal_ip_address_morsh_bastion,
      hostname1   = module.morsh_instance_ya_1.hostname_morsh_bastion,
      ip2         = module.morsh_instance_ya_2.internal_ip_address_morsh_bastion,
      hostname2   = module.morsh_instance_ya_2.hostname_morsh_bastion
      ip3         = module.morsh_instance_ya_3.internal_ip_address_morsh_bastion,
      hostname3   = module.morsh_instance_ya_3.hostname_morsh_bastion


    }
  )


}