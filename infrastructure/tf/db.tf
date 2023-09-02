resource "aws_db_subnet_group" "db_subnet_group" {
    name = "db_subnets"
    subnet_ids = [aws_subnet.db-sub-1.id,aws_subnet.db-sub-2.id]

}

resource "aws_db_instance" "wp-db" {
    allocated_storage = 5
    db_name = "wp-db"
    engine = "mysql"
    engine_version = "8.0.34"
    instance_class = "db.t4g.micro"
    username = "db_admin"
    password = "replace_me"
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
    skip_final_snapshot = true
    

    tags = {
        Name = "wp-db"
    }
}


resource "aws_elasticache_subnet_group" "memcache_sub_group" {
    name = "memcache_group"
    subnet_ids = [aws_subnet.db-sub-1.id,aws_subnet.db-sub-2.id]
}

resource "aws_elasticache_cluster" "wp-cache" {
    cluster_id = "wp-cache"
    engine = "memcached"
    node_type = "cache.t4g.micro"
    num_cache_nodes = 1
    port = 11211
    subnet_group_name = aws_elasticache_subnet_group.memcache_sub_group.name

}