import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name='us-east-1')  # Specify your region
    instances = ['i-01a16c5ac0ad916a9']  # Replace with your EC2 instance ID it is Jenkins ID
    ec2.stop_instances(InstanceIds=instances)
    print(f'Stopped instances: {instances}')