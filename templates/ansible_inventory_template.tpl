[database]
${hostname1} ansible_host=${ip1} ansible_user=${user_type_2}
[web]
${hostname1} ansible_host=${ip1} ansible_user=${user_type_2}
[app]
${hostname2} ansible_host=${ip2} ansible_user=${user_type_2}
${hostname3} ansible_host=${ip3} ansible_user=${user_type_1}
[database:vars]
pg_version=15
pg_data_root=/opt/pg_data


