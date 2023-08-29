data "aws_ami" "wp-image" {
    most_recent = true
    owners = ["181066809772"]
    name_regex = "wp-image"
}

resource "aws_launch_template" "wp-template" {
    name_prefix = "wp-image"
    image_id = "${data.aws_ami.wp-image.id}"
    instance_type = "t2.micro"
    update_default_version = true
    key_name = "main"

    network_interfaces {
        associate_public_ip_address = false
        security_groups = ["${aws_security_group.allow_lb.id}"]
    }

    user_data = filebase64("${path.module}/wp-startup.sh")

}

resource "aws_autoscaling_group" "wp-asg" {
    name = "wp_asg"
    desired_capacity = 1
    min_size = 1
    max_size = 4
    vpc_zone_identifier = [aws_subnet.app-sub-1.id,aws_subnet.app-sub-2.id]
    target_group_arns = [aws_lb_target_group.app-tg.arn]

    launch_template {
        id = aws_launch_template.wp-template.id
        version = "$Latest"
    }

    # Blue green deployment setting
    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_autoscaling_attachment" "asg-attach"{
    autoscaling_group_name = aws_autoscaling_group.wp-asg.name
    lb_target_group_arn = aws_lb_target_group.app-tg.arn
}