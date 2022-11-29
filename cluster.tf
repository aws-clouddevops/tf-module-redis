# Creates redis (Elastic Cache) Cluster

resource "aws_elasticache_cluster" "example" {
  cluster_id           = "cluster-example"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 2
  parameter_group_name = "default.memcached1.4"
  port                 = 11211
}
#  # Creates Docdb Cluster

# resource "aws_docdb_cluster" "docdb" {
#   cluster_identifier      = "roboshop-${var.ENV}"
#    engine                  = "docdb"
#   master_username         = "admin1"
#   master_password         = "roboshop1"
#   skip_final_snapshot     = true # True only during lab in prod, we will take a snapshot and that time this will be False
#   db_subnet_group_name    = aws_docdb_subnet_group.docdb.name
# }

# # Creates subnet group

# resource "aws_docdb_subnet_group" "docdb" {
#   name       = "roboshop-mongo-${var.ENV}"
#   subnet_ids =  data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

#   tags = {
#     Name = "My docdb subnet group"
#   }
# }

# # Creates DocDB cluster instance and adds then to the cluster

# resource "aws_docdb_cluster_instance" "cluster_instances" {
#   count              = 1
#   identifier         = "roboshop-${var.ENV}"
#   cluster_identifier = aws_docdb_cluster.docdb.id
#   instance_class     = "db.t3.medium"
# }

# # resource "aws_docdb_cluster" "default" {
# #   cluster_identifier = "docdb-cluster-demo"
# #   availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
# #   master_username    = "foo"
# #   master_password    = "barbut8chars"
# # }