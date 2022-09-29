data "aws_vpc" "default" {
    filter {
      name   = "tag:Name"
      values = ["dm-eu-west-2-dev-vpc"]
    }
  }
  
data "aws_subnet" "default" {
    vpc_id = data.aws_vpc.default.id
  
    filter {
      name = "tag:Name"
      values = ["dm-eu-west-2-dev-private-subnet"]
    }
}
