# Creates redis (Elastic Cache) Cluster

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "redis-${var.ENV}"
  engine               = "redis"
  node_type            = var.ELASTICCACHE_NODE_TYPE
  num_cache_nodes      = var.ELASTICCACHE_NODE_COUNT      # An ideal prod cluster should have 3 nodes
  parameter_group_name = aws_elasticache_parameter_group.default.name
  engine_version       = var.ELASTICCACHE_ENGINE_VERSION
  port                 = var.ELASTICCACHE_PORT
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
    description      = "Allow Redis Connection from default vpc"
    from_port        = var.ELASTICCACHE_PORT
    to_port          = var.ELASTICCACHE_PORT
    protocol         = "tcp"
    cidr_blocks      = [data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]
  }

  ingress {
    description      = "Allow redis Connection from Private vpc"
    from_port        = var.ELASTICCACHE_PORT
    to_port          = var.ELASTICCACHE_PORT
    protocol         = "tcp"
    cidr_blocks      = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
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
