
##!/bin/bash
export AWS_REGION=$(cat ~/.aws/config | grep '^region' | cut -d "=" -f 2); echo $AWS_REGION
export ACCOUNT_ID=$(aws sts get-caller-identity | grep Account | grep -Eo '\d+') ; echo $ACCOUNT_ID
export CLUSTER_NAME=$(cat ~/.aws/ecs-cluster-name); echo $CLUSTER_NAME
export CAPACITY_PROVIDER_NAME=$(aws ecs describe-clusters --clusters "$CLUSTER_NAME" | jq -r '.clusters[].capacityProviders[]'); echo $CAPACITY_PROVIDER_NAME
export ASG_NAME=$(aws ecs describe-capacity-providers --capacity-providers "$CAPACITY_PROVIDER_NAME" | jq -r  '.capacityProviders[].autoScalingGroupProvider.autoScalingGroupArn' | cut -d "/" -f 2); echo $ASG_NAME
export LAUNCH_CONFIGURATION_NAME=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names "$ASG_NAME" | jq -r '.AutoScalingGroups[].LaunchConfigurationName'); echo $LAUNCH_CONFIGURATION_NAME
export SECURITY_GROUP_ID=$(aws autoscaling describe-launch-configurations --launch-configuration-names "$LAUNCH_CONFIGURATION_NAME" | jq -r '.LaunchConfigurations[].SecurityGroups[]'); echo $SECURITY_GROUP_ID
export VPC_ID=$(aws ec2 describe-security-groups --group-ids "$SECURITY_GROUP_ID" | jq -r '.SecurityGroups[].VpcId'); echo $VPC_ID
export PRIVATE_SUBNET_IDS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Tier,Values=private"  --query "Subnets[].SubnetId" --output json | jq -c .); echo $PRIVATE_SUBNET_IDS
export PUBLIC_SUBNET_IDS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" "Name=tag:Tier,Values=public"  --query "Subnets[].SubnetId" --output text); echo $PUBLIC_SUBNET_IDS

# export STACK_NAME=ecs-stack 
