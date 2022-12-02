# Creates redis (Elastic Cache) Cluster

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "cluster-${var.ENV}"
  engine               = "redis"
  node_type            = "cache.t3.small"
  num_cache_nodes      = 1       # An ideal prod cluster should have 3 nodes
  parameter_group_name = aws_elasticache_parameter_group.default.name
  engine_version       = "6.x"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.subnet-group.name
  security_group_ids   = [aws_security_group.allow_redis.id]
}

# Creates Parameter group

resource "aws_elasticache_parameter_group" "default" {
  name   = "roboshop-redis-${var.ENV}"
  family = "redis6.x"
}

# Created subnet Group
resource "aws_elasticache_subnet_group" "subnet-group" {
  name       = "roboshop-redis-${var.ENV}"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS
}

# Creates Security group for redis

resource "aws_security_group" "allow_redis" {
  name        = "roboshop-redis-${var.ENV}"
  description = "roboshop-redis-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description      = "redis port from def vpc"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "roboshop-redis-sg-${var.ENV}"
  }
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