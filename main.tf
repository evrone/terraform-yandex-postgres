resource "yandex_mdb_postgresql_cluster" "managed_postgresql_cluster" {
  name        = var.cluster_name
  network_id  = var.network_id
  environment = var.environment

  dynamic "config" {
    for_each = var.config
    content {
      version                   = config.value["version"]
      backup_retain_period_days = config.value["backup_retain_period_days"]

      resources {
        resource_preset_id = config.value.resources["resource_preset_id"]
        disk_type_id       = config.value.resources["disk_type_id"]
        disk_size          = config.value.resources["disk_size"]
      }

      postgresql_config = {
        for k, v in config.value.postgresql_config : k => v
      }

      backup_window_start {
        hours   = config.value.backup_window_start["hour"]
        minutes = config.value.backup_window_start["minute"]
      }

      performance_diagnostics {
        enabled                      = config.value.performance_diagnostics["enabled"]
        sessions_sampling_interval   = config.value.performance_diagnostics["sessions_sampling_interval"]
        statements_sampling_interval = config.value.performance_diagnostics["statements_sampling_interval"]
      }
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
