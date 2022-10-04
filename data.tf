data "aws_vpc" "default" {
    filter {
      name   = "tag:Name"
      values = ["dm-eu-west-2-dev-vpc"]
    }
  }
  
data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "dm-eu-west-2-dev-private-subnet*"
  }

    filter {
      name   = "tag:availability-zone"
      values = ["eu-west-2a", "eu-west-2b"]
   }
}
