/*
provider "google" {
  version = "~> 3.3.0"
}


provider "null" {
  version = "~> 2.1"
}
*/

module "net-firewall" {
  source              = "terraform-google-modules/network/google//modules/fabric-net-firewall"
  project_id          = var.project_id
  network             = module.vpc.network_name
  custom_rules = {
     allow-all-admin-users = {
      description          = "Allow all traffic from admin-users"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["0.0.0.0/0"]
      use_service_accounts = false
      targets              = ["bastion"] # target_tags
      sources              = ["admin-users"] # Specific group of users
      rules = [{
        protocol = "tcp"
        ports    = ["22", "80", "443"] 
        }
      ]
      extra_attributes = {}
     }
     allow-web = {
      description          = "Allow traffic on web tier from internet on port 443"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["0.0.0.0/0"]
      use_service_accounts = false
      targets              = ["web-tier"] # target_tags
      sources              = null
      rules = [{
        protocol = "tcp"
        ports    = ["443"]
        }
      ]
      extra_attributes = {}
     }
     allow-web-to-app = {
      description          = "Allow web to app connection on port 80"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = null
      use_service_accounts = false
      targets              = ["app-tier"] # target_tags
      sources              = ["web-tier"]    # source_tags
      rules = [{
        protocol = "tcp"
        ports    = ["80"]
      }]

      extra_attributes = {}
    }
    deny-app-to-web = {
      description          = "Deny app to web connection on port 443"
      direction            = "INGRESS"
      action               = "deny"
      ranges               = null
      use_service_accounts = false
      targets              = ["web-tier"] # target_tags
      sources              = ["app-tier"]    # source_tags
      rules = [{
        protocol = "tcp"
        ports    = ["443"]
      }]

      extra_attributes = {}
    }
    allow-ssh-from-bastion = {
      description          = "Allow ssh from bastion host to web and app on internal ip's"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["10.10.10.0/24"]
      use_service_accounts = false
      targets              = ["app-tier", "web-tier"] # target_tags
      sources              = null
      rules = [{
        protocol = "tcp"
        ports    = ["80"]
      }]

      extra_attributes = {}
    }
  
  }

}
