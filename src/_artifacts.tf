locals {
  data_infrastructure = {
    grn = google_redis_instance.redis.id
  }

  data_authentication = {
    username = ""
    # the username above is intentially blank, this auth token can be used by itself
    password = google_redis_instance.redis.auth_string
    hostname = google_redis_instance.redis.host
    port     = google_redis_instance.redis.port
  }
  data_security = {
  }

  specs_cache = {
    "engine"  = "redis"
    "version" = lower(replace(trimprefix(google_redis_instance.redis.redis_version, "REDIS_"), "_", "."))
  }

  artifact_authentication = {
    data = {
      infrastructure = local.data_infrastructure
      authentication = local.data_authentication
      security       = local.data_security
    }
    specs = {
      cache = local.specs_cache
    }
  }
}

resource "massdriver_artifact" "authentication" {
  field                = "authentication"
  provider_resource_id = google_redis_instance.redis.id
  type                 = "redis-authentication"
  name                 = "Redis Cluster: (${google_redis_instance.redis.id})"
  artifact             = jsonencode(local.artifact_authentication)
}
