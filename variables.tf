# yandex_mdb_postgresql_cluster vars
variable "cluster_name" {
  type        = string
  description = "Unique for the cloud name of a cluster"
}

variable "environment" {
  type        = string
  default     = "PRODUCTION"
  description = "PRODUCTION or PRESTABLE. Prestable gets updates before production environment"
}

variable "backup_retain_period_days" {
  type    = number
  default = 14
}

variable "network_id" {
  type = string
}

variable "database_version" {
  type        = string
  default     = "14"
  description = "Version of PostgreSQL"
}

variable "resource_preset_id" {
  type        = string
  default     = "s2.small"
  description = "Id of a resource preset which means count of vCPUs and amount of RAM per host"
}

variable "disk_type_id" {
  type        = string
  default     = "network-ssd"
  description = "Disk type: 'network-ssd', 'network-hdd', 'local-ssd'"
}

variable "disk_size" {
  type        = number
  default     = 20
  description = "Disk size in GiB"
}

variable "max_connections" {
  type        = string
  default     = 395
  description = "determines the maximum number of concurrent connections to the database server"
}

variable "enable_parallel_hash" {
  type    = bool
  default = true
}

variable "vacuum_cleanup_index_scale_factor" {
  type    = number
  default = 0.2
}

variable "autovacuum_vacuum_scale_factor" {
  type    = number
  default = 0.34
}

variable "default_transaction_isolation" {
  type        = string
  default     = "TRANSACTION_ISOLATION_READ_COMMITTED"
  description = "This setting defines the default isolation level to be set for all new SQL transactions"
}

variable "shared_preload_libraries" {
  type        = string
  default     = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
  description = "determining which libraries are to be loaded when PostgreSQL starts"
}

# Optional user variables for postgresql
# Full description https://cloud.yandex.com/en-ru/docs/managed-postgresql/api-ref/grpc/user_service#UserSettings1

variable "settings_default_transaction_isolation" {
  type        = string
  default     = "read committed"
  description = "SQL sets an isolation level for each transaction. This setting defines the default isolation level to be set for all new SQL transactions. defines the default isolation level to be set for all new SQL transactions. "
}

variable "settings_log_min_duration_statement" {
  type        = number
  default     = 5000
  description = "This setting controls logging of the duration of statements. "
}

variable "settings_lock_timeout" {
  type        = number
  default     = 0
  description = "The maximum time (in milliseconds) for any statement to wait for acquiring a lock on an table, index, row or other database object "
}

variable "settings_synchronous_commit" {
  type        = number
  default     = 1
  description = "This setting defines whether DBMS will commit transaction in a synchronous way."
}

variable "settings_temp_file_limit" {
  type        = number
  default     = -1
  description = "The maximum storage space size (in kilobytes) that a single process can use to create temporary files."
}

variable "settings_log_statement" {
  type        = string
  default     = "none"
  description = "This setting specifies which SQL statements should be logged (on the user level). "
}

# Main user defined varibales

variable "maintenance_window" {
  description = "Maintenance policy of the PostgreSQL cluster"
  type = object({
    type = string
    day  = string
    hour = number
  })
}

variable "databases" {
  description = "List of databases for creation"
  type = map(object({
    owner      = string
    lc_collate = string
    lc_type    = string
  }))
}

variable "users" {
  description = "List of users in databases"
  type = map(object({
    password   = string
    conn_limit = number
    permissions = list(object({
      database_name = string
    }))
  }))
}

variable "hosts" {
  description = "Configuration of databases hosts"
  type = map(object({
    name      = string
    zone      = string
    subnet_id = string
  }))
}

# PostgreSQL Odyssey pooler config
variable "pool_discard" {
  type    = bool
  default = true
}

variable "pooling_mode" {
  type    = string
  default = "SESSION"
}
