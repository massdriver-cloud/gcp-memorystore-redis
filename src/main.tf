locals {
  connect_mode = true ? "PRIVATE_SERVICE_ACCESS" : "DIRECT_PEERING"

  tier                = var.tier == "Single Instance" ? "BASIC" : "STANDARD_HA"
  is_highly_available = local.tier == "STANDARD_HA"

  version_map = {
    "3.2" = "REDIS_3_2"
    "4.0" = "REDIS_4_0"
    "5.0" = "REDIS_5_0"
    "6.x" = "REDIS_6_X"
  }
}

resource "google_redis_instance" "redis" {
  provider       = google-beta
  name           = var.md_metadata.name_prefix
  labels         = var.md_metadata.default_tags
  tier           = local.tier
  memory_size_gb = var.memory_size_gb

  region = var.subnetwork.specs.gcp.region

  authorized_network = var.subnetwork.data.infrastructure.gcp_global_network_grn
  connect_mode       = local.connect_mode

  redis_version = local.version_map[var.redis_version]
  display_name  = var.md_metadata.name_prefix

  read_replicas_mode = local.is_highly_available ? "READ_REPLICAS_ENABLED" : null
  replica_count      = local.is_highly_available ? var.read_replicas : null

  # OSS Redis AUTH
  auth_enabled            = true
  transit_encryption_mode = var.tls_enabled ? "SERVER_AUTHENTICATION" : "DISABLED"

  lifecycle {
    ignore_changes = [
      # Ignore changes to transit_encryption_mode
      # make adding this backwards-compat with existing instances
      transit_encryption_mode
    ]
  }

  depends_on = [
    module.apis
  ]
}
