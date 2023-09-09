resource "aws_efs_file_system" "wp-fs" {
    creation_token = "wordpress-fs"

    tags = {
        Name = "wordpress-fs"
    }
}

resource "aws_efs_mount_target" "db-1-tg" {
    file_system_id = aws_efs_file_system.wp-fs.id
    subnet_id = aws_subnet.db-sub-1.id
}

resource "aws_efs_mount_target" "db-2-tg" {
    file_system_id = aws_efs_file_system.wp-fs.id
    subnet_id = aws_subnet.db-sub-2.id
}