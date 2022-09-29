region = "eu-west-2"
role_arn = "arn:aws:iam::405079206131:role/dm-eu-west-2-dev-iam"

######## SGs ##
use_dynamic_name="dev-ui-asg"
eks_sg = "sg-0707d81610954ddf3"

######## ASG Shared Variables ##
addroletovault = true
haspolicycodedeploy = true
cpu_utilization_value = 60

######## ASG Additional Variables ##
image_id = "ami-0f540e9f488cfa27d"
instance_type = "t2.micro"
key_name = "dm-eu-west-2-dev-kp"
iam_profile_arn = "arn:aws:iam::405079206131:instance-profile/dm-eu-west-2-dev-iam"
name_prefix = "dm-eu-west-2-dev-vpc"

## sizes for UI servers
max_size = "1"
min_size = "1"
desired_size = "1"
scaleinoncpu = true
user_data = "dev/user-data.tpl"

