provider "alicloud" {
  #   access_key = "${var.access_key}"
  #   secret_key = "${var.secret_key}"
  region = "me-central-1"
}

variable "zone_1" {
  default = "me-central-1b"
}

variable "zone_2" {
  default = "me-central-1c"
}

variable "redis_multizone" {
  default = "me-central-(a,b)" //change later
}

variable "name" {
  default = "wp_group"
}

######## Security group
resource "alicloud_security_group" "group" {
  name        = "sg_solution_cloud_native_wordpress"
  description = "Security group for cloud native wordpress solution"
  vpc_id      = alicloud_vpc.vpc.id
}

resource "alicloud_security_group_rule" "allow_http_80" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_https_443" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_ssh_22" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_rdp_3389" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "3389/3389"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_all_icmp" {
  type              = "ingress"
  ip_protocol       = "icmp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

######## VPC
resource "alicloud_vpc" "vpc" {
  vpc_name   = var.name
  cidr_block = "192.168.0.0/16"
}

resource "alicloud_vswitch" "vswitch_1" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "192.168.0.0/24"
  zone_id      = var.zone_1
  vswitch_name = "vsw_on_zone_1"
}

resource "alicloud_vswitch" "vswitch_2" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "192.168.1.0/24"
  zone_id      = var.zone_2
  vswitch_name = "vsw_on_zone_2"
}

######## Redis
resource "alicloud_kvstore_instance" "example" {
  db_instance_name  = "wpdb"
  vswitch_id        = alicloud_vswitch.vswitch_1.id
  security_group_id = alicloud_security_group.group.id
  security_ips      = ["192.168.0.0/16"]
  instance_type     = "Redis"
  engine_version    = "4.0"
  config = {
    appendonly             = "yes",
    lazyfree-lazy-eviction = "yes",
  }
  tags = {
    Created = "TF",
    For     = "Test",
  }
  resource_group_id = "rg-123456"
  # zone_id           = data.alicloud_zones.default.zones[0].id
  zone_id        = var.redis_multizone
  instance_class = "redis.master.small.default"
}

resource "alicloud_kvstore_account" "example" {
  account_name     = "" ##  change accordingly
  account_password = ""   ##  change accordingly
  instance_id      = alicloud_kvstore_instance.example.id
}

####### RDSDB MySQL
resource "alicloud_rdsdb_" "" //to check later
 {
  db_type       = "MySQL"
  db_version    = "5.6"
  db_node_class = "polar.mysql.x4.medium"
  pay_type      = "PostPaid"
  security_ips  = ["192.168.0.0/16"]
  vswitch_id    = alicloud_vswitch.vswitch_2.id
  description   = "wpdb"
}

resource "alicloud_rdsdb_account" "account" {
  db_cluster_id       = alicloud_rdsdb_cluster.cluster.id //change 
  account_name        = "" ## Please change accordingly
  account_password    = ""     ## Please change accordingly
  account_description = "wpdb"
}

resource "alicloud_rdsdb_database" "default" {
  db_cluster_id = alicloud_rdsdb_cluster.cluster.id // change
  db_name       = "wpdb" ## change 
}

resource "alicloud_rdsdb_account_privilege" "privilege" {
  db_cluster_id     = alicloud_rdsdb_cluster.cluster.id ##change
  account_name      = alicloud_rdsdb_account.account.account_name ##change
  account_privilege = "ReadWrite"
  db_names          = [alicloud_rdsdb_database.default.db_name] 
}

######## ECS
resource "alicloud_instance" "instance" {
  security_groups = alicloud_security_group.group.*.id

  # series III
  instance_type           = "ecs.c6.xlarge"
  system_disk_category    = "cloud_essd"
  system_disk_name        = "wp_system_disk_name"
  system_disk_size        = 40
  system_disk_description = "wp_system_disk_description"
  image_id                = "centos_8_3_x64_20G_alibase_20210723.vhd"
  instance_name           = "wp"
  password                = "" ##  change 
  instance_charge_type    = "PostPaid"
  vswitch_id              = alicloud_vswitch.vswitch_1.id
}

######## SLB
resource "alicloud_slb" "default" {
  load_balancer_name = "wp_slb"
  load_balancer_spec = "slb.s2.medium"
  vswitch_id         = alicloud_vswitch.vswitch_1.id
  master_zone_id     = var.zone_1
  slave_zone_id      = var.zone_2
}

resource "alicloud_slb_listener" "default" {
  load_balancer_id          = alicloud_slb.default.id
  backend_port              = 80
  frontend_port             = 80
  protocol                  = "http"
  bandwidth                 = 10
  sticky_session            = "on"
  sticky_session_type       = "insert"
  cookie_timeout            = 86400
  cookie                    = "testslblistenercookie"
  health_check              = "on"
  health_check_uri          = "/"
  health_check_connect_port = 80
  healthy_threshold         = 8
  unhealthy_threshold       = 8
  health_check_timeout      = 8
  health_check_interval     = 5
  health_check_http_code    = "http_2xx,http_3xx,http_4xx"
  x_forwarded_for {
    retrive_slb_ip = true
    retrive_slb_id = true
  }
  request_timeout = 80
  idle_timeout    = 30
}

resource "alicloud_slb_backend_server" "default" {
  load_balancer_id = alicloud_slb.default.id

  backend_servers {
    server_id = alicloud_instance.instance.id
    weight    = 50
  }
}

######## EIP bind to wordpress setup ECS accessing from internet
resource "alicloud_eip" "setup_ecs_access" {
  bandwidth            = "10"
  internet_charge_type = "PayByBandwidth" ##change
}

resource "alicloud_eip_association" "eip_ecs" {
  allocation_id = alicloud_eip.setup_ecs_access.id
  instance_id   = alicloud_instance.instance.id
}

######## EIP bind to SLB for Wordpress website accessing from internet
resource "alicloud_eip" "website_slb_access" {
  bandwidth            = "10"
  internet_charge_type = "PayByBandwidth"
}

resource "alicloud_eip_association" "eip_slb" {
  allocation_id = alicloud_eip.website_slb_access.id
  instance_id   = alicloud_slb.default.id
}

######### Output: EIP of ECS
output "eip_ecs" {
  value = alicloud_eip.setup_ecs_access.ip_address
}

######### Output: rdsdb MySQL connection string
output "alicloud_rdsdb_cluster" {   ##change
  value = alicloud_rdsdb_cluster.cluster.connection_string
}

######### Output: Redis connection string
output "alicloud_kvstore_instance" {
  value = alicloud_kvstore_instance.example.connection_domain
}
