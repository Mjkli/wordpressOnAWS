# WordPressOnAWS
This is a project showing the build and configuration of a wordpress service hosted on AWS. We will work through how to setup the configuration files, create amis for autoscaling, RDS and Memcache for database service, and how to host the configuration files on EFS so that when new instances come up they are already configured and connected.

This project will not only create the environment to configure wordpress, but it will setup wordpress in the efs we need and attach to the rds database on the fly. So that when we launch this project everything should be configured and you should be prompted with a default login everytime.

## Diagram
![Alt text](https://github.com/Mjkli/wordpressOnAWS/blob/master/diagram.png)

Diagram referenced from: https://docs.aws.amazon.com/whitepapers/latest/best-practices-wordpress/reference-architecture.html