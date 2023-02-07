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


