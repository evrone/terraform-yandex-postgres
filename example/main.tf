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

  postgresql_config = [{
    auto_explain_log_buffers = true
    log_error_verbosity = "LOG_ERROR_VERBOSITY_UNSPECIFIED"
  }]

  # resource_preset_id = "b1.nano"
  # disk_size          = 10
  # disk_type_id       = "network-hdd"

  databases = {
    test_db = {
      owner      = "test_user"
      lc_collate = "en_US.UTF-8"
      lc_type    = "en_US.UTF-8"
    },
    test2_db = {
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
          database_name = "test2_db"
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
