# WordPressOnAWS
This is a project showing the build and configuration of a wordpress service hosted on AWS. We will work through how to setup the configuration files, create amis for autoscaling, RDS and Memcache for database service, and how to host the configuration files on EFS so that when new instances come up they are already configured and connected.

## Diagram
Diagram taken from this link: https://docs.aws.amazon.com/whitepapers/latest/best-practices-wordpress/reference-architecture.html
![Alt text](https://github.com/Mjkli/wordpressOnAWS/blob/master/diagram.png)