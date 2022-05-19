output "cluster_id" {
  value     = module.mdb_postgresql.cluster_id
  sensitive = false
}

output "cluster_host_fqdn" {
  value     = module.mdb_postgresql.cluster_host_fqdn
  sensitive = false
}

output "cluster_users" {
  value     = module.mdb_postgresql.cluster_users
  sensitive = true
}

output "cluster_databases" {
  value = module.mdb_postgresql.cluster_databases
}

output "user_passwords" {
  value     = module.mdb_postgresql.user_passwords
  sensitive = true
}
