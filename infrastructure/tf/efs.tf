resource "aws_efs_file_system" "wp-fs" {
    creation_token = "wordpress-fs"

    tags = {
        Name = "wordpress-fs"
    }

}