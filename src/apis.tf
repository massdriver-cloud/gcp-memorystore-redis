
module "apis" {
  source = "../../../provisioners/terraform/modules/gcp-apis"
  services = [
    "redis.googleapis.com"
  ]
}
