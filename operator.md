## Google Cloud Memorystore for Redis

Google Cloud Memorystore for Redis is a fully managed, in-memory data store service built on Redis. It provides a robust and high-performance caching layer that integrates seamlessly with Google Cloud applications.

### Design Decisions

We have made several design decisions to optimize the use of Google Cloud Memorystore for Redis:

- **High Availability:** Optional support for high availability using `STANDARD_HA` tier, which includes read replicas for enhanced resilience.
- **Private Service Access:** Configure connections to Memorystore through private service access for enhanced security.
- **Version Management:** Supports multiple Redis versions with seamless upgrades.
- **Monitoring and Alarms:** Includes built-in alarms for critical metrics like memory usage.
- **Authentication and Security:** Redis AUTH is enabled for securing access to the instance.
  
### Runbook

#### Checking Instance Status

If you're experiencing connectivity or performance issues, the first step is to check the status of your Redis instance.

```sh
gcloud redis instances describe [INSTANCE_ID] --region=[REGION]
```

You should see details about the instance's status, memory usage, and network connectivity. Look for the `state` field to confirm that the instance is operational.

#### Viewing Log Entries

To help diagnose issues, you can check the log entries associated with your Redis instance.

```sh
gcloud logging read "resource.type=redis_instance AND resource.labels.instance_id=[INSTANCE_ID]" --limit 30
```

This will return the latest log entries related to your Redis instance, which may contain error messages or other diagnostic information.

#### Redis Performance Issues

If your Redis instance is experiencing slow performance, you can use the `redis-cli` tool to connect to the instance and run diagnostic commands.

```sh
redis-cli -h [HOST] -p [PORT] -a [AUTH_STRING]
```

Once connected, you can run the following commands to check performance:

- **Checking Memory Usage:**
  ```sh
  info memory
  ```
  Look for the `used_memory` and `used_memory_peak` fields to understand how much memory is being consumed.

- **Checking Slow Queries:**
  ```sh
  slowlog get 10
  ```
  This retrieves the last 10 queries that took the longest time to execute. If you see many slow queries, consider optimizing your queries or upgrading your instance size.

#### High Memory Usage Alerts

If you've received an alert for high memory usage, it may be necessary to clear some cache or upgrade your instance.

- **Flushing All Data:**
  Keep in mind this will remove all data from the Redis instance.
  ```sh
  redis-cli -h [HOST] -p [PORT] -a [AUTH_STRING] FLUSHALL
  ```

- **Evicting Keys Based on Policy:**
  Configure an eviction policy if one isn't already set to manage memory usage gracefully.
  ```sh
  redis-cli -h [HOST] -p [PORT] -a [AUTH_STRING] config set maxmemory-policy allkeys-lru
  ```

#### Connectivity Issues

If you experience connectivity issues:

- **Check Authorized Networks:**
  Ensure your VPC network is authorized to connect to the Redis instance.
  ```sh
  gcloud redis instances describe [INSTANCE_ID] --region=[REGION] --format="get(authorizedNetwork)"
  ```
  
- **Ping the Redis Endpoint:**
  Verify you can reach the Redis endpoint from your application.
  ```sh
  ping [HOST]
  ```

