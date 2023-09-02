provider "aws"{
    region = "us-west-1"
}

terraform {
  backend "s3"{
    encrypt = true
    bucket = "state-storage-mjkli"
    dynamodb_table = "wp-state-lock"
    key = "wordpressOnAWS-tf-state"
    region = "us-west-1"
  }
}
