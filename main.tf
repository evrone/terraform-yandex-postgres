resource "yandex_mdb_postgresql_cluster" "managed_postgresql_cluster" {
  name        = var.cluster_name
  network_id  = var.network_id
  environment = var.environment

  config {
    version                   = var.database_version
    backup_retain_period_days = var.backup_retain_period_days

    resources {
      resource_preset_id = var.resource_preset_id
      disk_type_id       = var.disk_type_id
      disk_size          = var.disk_size
    }

    pooler_config {
      pool_discard = var.pool_discard
      pooling_mode = var.pooling_mode
    }

    postgresql_config = {
      max_connections                   = var.max_connections
      enable_parallel_hash              = var.enable_parallel_hash
      vacuum_cleanup_index_scale_factor = var.vacuum_cleanup_index_scale_factor
      autovacuum_vacuum_scale_factor    = var.autovacuum_vacuum_scale_factor
      default_transaction_isolation     = var.default_transaction_isolation
      shared_preload_libraries          = var.shared_preload_libraries
    }
  }

  maintenance_window {
    type = var.maintenance_window.type
    day  = var.maintenance_window.day
    hour = var.maintenance_window.hour
  }

  dynamic "database" {
    for_each = var.databases
    content {
      name       = database.key
      owner      = database.value.owner
      lc_collate = database.value.lc_collate
      lc_type    = database.value.lc_type
    }
  }

  dynamic "user" {
    for_each = var.users
    content {
      name       = user.key
      password   = user.value.password
      conn_limit = user.value.conn_limit

      dynamic "permission" {
        for_each = user.value["permissions"]
        content {
          database_name = permission.value.database_name
        }
      }
      settings = {
        default_transaction_isolation = var.settings_default_transaction_isolation
        lock_timeout                  = var.settings_lock_timeout
        log_min_duration_statement    = var.settings_log_min_duration_statement
        synchronous_commit            = var.settings_synchronous_commit
        temp_file_limit               = var.settings_temp_file_limit
        log_statement                 = var.settings_log_statement
      }
    }
  }

  dynamic "host" {
    for_each = var.hosts
    content {
      name      = host.value.name
      zone      = host.value.zone
      subnet_id = host.value.subnet_id
    }
  }
}
