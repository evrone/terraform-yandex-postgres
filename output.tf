output "cluster_id" {
  value = yandex_mdb_postgresql_cluster.managed_postgresql_cluster.id
}

output "cluster_host_fqdn" {
  value = [
    for fqdn in yandex_mdb_postgresql_cluster.managed_postgresql_cluster.host : fqdn.fqdn
  ]
}

output "cluster_users" {
  value = [
    for user in yandex_mdb_postgresql_cluster.managed_postgresql_cluster.user : user.name
  ]
}

output "cluster_databases" {
  value = [
    for db in yandex_mdb_postgresql_cluster.managed_postgresql_cluster.database : db.name
  ]
}

output "user_passwords" {
  value = {
    for user in yandex_mdb_postgresql_cluster.managed_postgresql_cluster.user : user.name => user.password
  }
}

output "postgresql_config" {
  value = yandex_mdb_postgresql_cluster.managed_postgresql_cluster.config[0].postgresql_config
}
