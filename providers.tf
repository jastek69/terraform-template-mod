# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.
# Tokyo - HQ region


provider "aws" {
  region = "ap-northeast-1"
}


/***************************************************************************************************************/
/* 
# Australia - Additional provider configuration for Asia Pacific region
# reference this as `aws.australia`.
provider "aws" {
  alias  = "australia"
  region = "ap-southeast-2"
}


# Hong Kong - additional provider configuration for Asia Pacific region
# reference this as `aws.hongkong`.
provider "aws" {
  alias  = "hongkong"
  region = "ap-east-1"
}


# London - additional provider configuration for Asia Pacific region
# reference this as `aws.london`.
provider "aws" {
  alias  = "london"
  region = "eu-west-2"
}


# Sao Paulo - additional provider configuration for Asia Pacific region
# reference this as `aws.sao`.
provider "aws" {
  alias  = "sao"
  region = "sa-east-1"
}


# California - additional provider configuration for Asia Pacific region
# reference this as `aws.ca`.
provider "aws" {
  alias  = "ca"
  region = "us-west-1"
}


# New York (Virginia)- additional provider configuration for Asia Pacific region
# reference this as `aws.ny`.
provider "aws" {
  alias  = "ny"
  region = "us-east-1"
}
*****************************************************************************************************************/


# Providers - terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46.0" 
    }
  }
}
