
module "apis" {
  source = "github.com/massdriver-cloud/terraform-google-enable-apis"
  services = [
    "redis.googleapis.com"
  ]
}
