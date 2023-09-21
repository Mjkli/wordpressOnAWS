output "memcache_endpoint_nodes" {
    value = aws_elasticache_cluster.wp-cache.cache_nodes
}