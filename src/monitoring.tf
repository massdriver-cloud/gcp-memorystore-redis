
locals {
  threshold_cpu    = 0.9
  threshold_disk   = 0.9
  threshold_memory = 0.9

  metrics = {
    # "cpu" = {
    #   metric   = "cloudsql.googleapis.com/database/cpu/utilization"
    #   resource = "cloudsql_database"
    # }
    # "disk" = {
    #   metric   = "cloudsql.googleapis.com/database/disk/utilization"
    #   resource = "cloudsql_database"
    # }
    "memory" = {
      metric   = "redis.googleapis.com/stats/memory/usage_ratio"
      resource = "redis_instance"
    }
  }
}

module "alarm_channel" {
  source      = "github.com/massdriver-cloud/terraform-modules//gcp-alarm-channel?ref=bfcf556"
  md_metadata = var.md_metadata
}

# module "database_cpu_alarm" {
#   source        = "github.com/massdriver-cloud/terraform-modules//gcp-monitoring-utilization-threshold?ref=cafdc89"
#   md_metadata   = var.md_metadata
#   message       = "Cloud SQL Postgres ${google_redis_instance.redis.id}: CPU Utilization over threshold ${local.threshold_cpu * 100}%"
#   alarm_name    = "${google_redis_instance.redis.id}-highCPU"
#   metric_type   = local.metrics["cpu"].metric
#   resource_type = local.metrics["cpu"].resource
#   threshold     = local.threshold_cpu
#   period        = 60
#   duration      = 60

#   depends_on = [
#     google_redis_instance.redis
#   ]
# }


# module "database_disk_alarm" {
#   source        = "github.com/massdriver-cloud/terraform-modules//gcp-monitoring-utilization-threshold?ref=cafdc89"
#   md_metadata   = var.md_metadata
#   message       = "Cloud SQL Postgres ${google_redis_instance.redis.id}: Disk capacity over threshold ${local.threshold_disk * 100}%"
#   alarm_name    = "${google_redis_instance.redis.id}-highDisk"
#   metric_type   = local.metrics["disk"].metric
#   resource_type = local.metrics["disk"].resource
#   threshold     = local.threshold_disk
#   period        = 60
#   duration      = 60

#   depends_on = [
#     google_redis_instance.redis
#   ]
# }

module "database_memory_alarm" {
  source                  = "github.com/massdriver-cloud/terraform-modules//gcp-monitoring-utilization-threshold?ref=cafdc89"
  notification_channel_id = module.alarm_channel.id
  md_metadata             = var.md_metadata
  display_name            = "Memory Usage"
  message                 = "Cloud SQL Postgres ${google_redis_instance.redis.id}: Memory capacity over threshold ${local.threshold_memory * 100}%"
  alarm_name              = "${google_redis_instance.redis.id}-highMemory"
  metric_type             = local.metrics["memory"].metric
  resource_type           = local.metrics["memory"].resource
  threshold               = local.threshold_memory
  period                  = 60
  duration                = 60

  depends_on = [
    google_redis_instance.redis
  ]
}
