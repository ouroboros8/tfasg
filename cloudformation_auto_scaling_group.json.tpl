{
  "Resources": {
    "MyAsg": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "AvailabilityZones": "Fn::GetAZs",
        "LaunchConfigurationName": "${aws_launch_configuration.launch_configuration.name}",
        "MaxSize": "${var.max_size}",
        "MinSize": "${var.min_size}",
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
