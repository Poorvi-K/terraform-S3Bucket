######PROVIDERS DETAIL#######

provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

########LOCALS########
######################

locals {
  common_tags = {
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
  }

  s3bucketname = "${var.bucket_name_prefix}--${var.environment_tag}--${random_integer.rand.result}"
}



resource "random_integer" "rand" {
  min= "98"
  max = "101"
  
}


#######CREATING S3 BUCKET########


  resource "aws_s3_bucket" "web_bucket" {
    bucket        = local.s3bucketname
    acl           = "private"
    force_destroy = true

    tags = merge(local.common_tags, { Name = "${var.environment_tag}-web-bucket" })

  

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
  }

###CREATE S3 LOG Bucket####


resource "aws_s3_bucket" "log_bucket" {
  bucket = "p-s-ft"
  acl = "log-delivery-write"
  
}




