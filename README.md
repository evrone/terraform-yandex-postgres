# Yandex cloud Managed PostgreSQL terraform module

# Usage

This module creates databases and users with nessecary permissions. Some important things before usage:
1. configure maintenance_window
2. specify the encoding - after creation DB there is no possibility to change it 
3. specify resource PostgreSQL cluster: instance type by cpu, type and size of disk
4. for create HA instance specify multiple "hosts" block
5. read the full doc of yandex: https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_postgresql_cluster

```
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
    }
    backup_window_start = {
      hour   = 3
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
```
