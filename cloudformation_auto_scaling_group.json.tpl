{
  "Resources": {
    "MyAsg": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "AvailabilityZones": {"Fn::GetAZs": "eu-west-2"},
        "LaunchConfigurationName": "${launch_configuration}",
        "MaxSize": ${max_size},
        "MinSize": ${min_size}
      },
      "UpdatePolicy": {
        "AutoScalingRollingUpdate": {
          "MinInstancesInService": "2",
          "MaxBatchSize": "1",
          "PauseTime": "PT0S"
        }
      }
    }
  }
}
