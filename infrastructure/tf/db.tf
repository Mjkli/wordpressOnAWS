resource "aws_db_subnet_group" "db_subnet_group" {
    name = "db_subnets"
    subnet_ids = [aws_subnet.db-sub-1.id,aws_subnet.db-sub-2.id]

}

resource "aws_db_instance" "wp-db" {
    allocated_storage = 5
    db_name = "wpdb"
    engine = "mysql"
    engine_version = "8.0.34"
    instance_class = "db.t4g.micro"
    username = "db_admin"
    password = var.rds_pass
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
    skip_final_snapshot = true
    vpc_security_group_ids = [ aws_security_group.allow_mysql.id ]

    tags = {
        Name = "wp-db"
    }
}

resource "aws_elasticache_subnet_group" "memcache_sub_group" {
    name = "memcachegroup"
    subnet_ids = [aws_subnet.db-sub-1.id,aws_subnet.db-sub-2.id]
}

resource "aws_elasticache_cluster" "wp-cache" {
    cluster_id = "wp-cache"
    engine = "memcached"
    node_type = "cache.t4g.micro"
    num_cache_nodes = 1
    port = 11211
    subnet_group_name = aws_elasticache_subnet_group.memcache_sub_group.name
    security_group_ids = [ aws_security_group.allow_memcache.id ]

}