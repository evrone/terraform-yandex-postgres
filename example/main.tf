provider "yandex" {
  token     = var.token
  cloud_id  = var.yc_cloud_id
  zone      = var.zone
  folder_id = var.folder_id
}

resource "yandex_vpc_network" "foo" {}

resource "yandex_vpc_subnet" "foo" {
  zone           = var.zone
  network_id     = yandex_vpc_network.foo.id
  v4_cidr_blocks = ["10.5.0.0/24"]
}



################################################################################
# Yandex Cloud Managed PostgreSQL Module
################################################################################

module "mdb_postgresql" {
  source = "../"

  cluster_name = "example_cluster"
  network_id   = yandex_vpc_network.foo.id
  environment  = "PRESTABLE"

  maintenance_window = {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }

  config = [{
    version                   = 14
    backup_retain_period_days = 7
    postgresql_config = {
      max_connections                   = 395
      enable_parallel_hash              = true
      vacuum_cleanup_index_scale_factor = 0.2
      autovacuum_vacuum_scale_factor    = 0.34
      default_transaction_isolation     = "TRANSACTION_ISOLATION_READ_COMMITTED"
      shared_preload_libraries          = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
    }
    backup_window_start = {
      hour   = 10
      minute = 0
    }
    performance_diagnostics = {
      enabled                      = false
      sessions_sampling_interval   = 60
      statements_sampling_interval = 600
    }
    resources = {
      resource_preset_id = "b1.nano"
      disk_type_id       = "network-hdd"
      disk_size          = 10
    }
  }]

  databases = {
    test_db = {
      owner      = "test_user"
      lc_collate = "en_US.UTF-8"
      lc_type    = "en_US.UTF-8"
    },
    test22_db = {
      owner      = "test2_user"
      lc_collate = "en_US.UTF-8"
      lc_type    = "en_US.UTF-8"
    }
  }

  users = {
    test_user = {
      password   = "test_user@!!#"
      conn_limit = 20
      permissions = [
        {
          database_name = "test_db"
        }
      ]
    },
    test2_user = {
      password   = "test2_user@!!#"
      conn_limit = 20
      permissions = [
        {
          database_name = "test22_db"
        }
      ]
    },
    test3_user = {
      password   = "test2_user@!!#"
      conn_limit = 20
      permissions = [
        {
          database_name = "test22_db"
        }
      ]
    }
  }

  hosts = {
    host1 = {
      name      = "host1"
      zone      = var.zone
      subnet_id = yandex_vpc_subnet.foo.id
    }
  }

}
