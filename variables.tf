# yandex_mdb_postgresql_cluster vars

variable "config" {
  description = "for dynamic block 'config' "
  type = list(object({
    backup_retain_period_days = number
    version                   = number
    postgresql_config = object({
      max_connections                   = number
      enable_parallel_hash              = bool
      vacuum_cleanup_index_scale_factor = number
      autovacuum_vacuum_scale_factor    = number
      default_transaction_isolation     = string
      shared_preload_libraries          = string
    })
    backup_window_start = object({
      hour   = number
      minute = number
    })
    performance_diagnostics = object({
      enabled                      = bool
      sessions_sampling_interval   = number
      statements_sampling_interval = number
    })
    resources = object({
      resource_preset_id = string
      disk_type_id       = string
      disk_size          = number
    })

  }))
}

variable "cluster_name" {
  type        = string
  description = "Unique for the cloud name of a cluster"
}

variable "environment" {
  type        = string
  default     = "PRODUCTION"
  description = "PRODUCTION or PRESTABLE. Prestable gets updates before production environment"
}

variable "network_id" {
  type = string
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
