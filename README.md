# WordPressOnAWS

This is a project showing the build and configuration of a wordpress service hosted on AWS. We will work through how to setup the configuration files, create amis for autoscaling, RDS and Memcache for database service, and how to host the configuration files on EFS so that when new instances come up they are already configured and connected.

This project will not only create the environment to configure wordpress, but it will setup wordpress in the efs we need and attach to the rds database on the fly. So that when we launch this project everything should be configured and you should be prompted with a default login everytime.

## Diagram
![Alt text](https://github.com/Mjkli/wordpressOnAWS/blob/master/diagram.png)

Diagram referenced from: https://docs.aws.amazon.com/whitepapers/latest/best-practices-wordpress/reference-architecture.html

## How to Use
First: Make sure that you have these variables in your github action secrets. If you plan on using this project locally. Make sure you have your aws cli credentials connected, and you remove the "backend" block in infrastructure/tf/main.tf

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
RDS_PASSWORD

Second: Make sure you have access to the domain you want to host on aws. This project will use a custom domain to host the infrastructure in https.

Three: To deploy infrastructure you will need to either push to your private repo with the variables set, (RDS and Domain), or make sure you run the packer build then terraform build. (The commands are spelled out in the github actions yml.)

## Issues along the way

### Installing wordpress on EFS.
    This proved to be difficult because you cannot access an EFS share before it is mounted to an instance. To solve this. I used the User data portion of an ec2 instance startup to mount the efs share and to check if anything was there. If not then it will download and install the wordpress files there.

### Setting up HTTPS proved to be a challenge as I needed to re-configure multiple parts of the infrastructure to handle the different style request.

    1. wordpress configuration needed to be adjusted  - https://aws.amazon.com/blogs/opensource/enabling-https-offloading-for-wordpress-blog-posts-in-aws-govcloud/
    2. Certificates needed to be made - along with purchasing a domain name.
    3. routing http requests to the Https protocol.
    4. Identifying the path of the requests. ( this requires adding a custom header to cloudfront and only allowing requests that have that header reach the ALB. Otherwise users can access the ALB without going through Cloudfront)

### Setting up Elasti-Cache
This becomes an issue because it requires manual setup to do. To accomplish this we have to manually install the W3 Total Cache
![Alt text](https://github.com/Mjkli/wordpressOnAWS/blob/master/documentation/Installing_cache_app_w3.PNG)

After the plugin is installed we need to configure the plugin to connect to the memcache (elasticache) database
Enable Memcached in the database cache section

![Alt text](https://github.com/Mjkli/wordpressOnAWS/blob/master/documentation/w3_settings.png)

Select Advanced Settings
Configure the following

![Alt text](https://github.com/Mjkli/wordpressOnAWS/blob/master/documentation/w3_advanced_settings.png)

Locate the Memcached hostname:port / IP: port settings given by the terraform output.

### Configuring Autoscaling
Needed to test the autoscaling of and found I had not added autoscaling policies. Once added if the current wp image CPU hits 60% load another instance will spin up and start loadbalancing the traffic.
I tested the network traffic using siege, an HTTP/S load tester and benchmarking utility.

## Things I would fix If I continued working on this project.

1 - When a new instance comes up it defaults to the apache default site then comes up. this inital start up is not ideal.
2 - Defining read replicas so that database access will be more streamed line. (there is a plugin we can use)
