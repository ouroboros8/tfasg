{
  "Resources": {
    "MyAsg": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "AvailabilityZones": {"Fn::GetAZs": "${region}"},
        "LaunchConfigurationName": "${launch_configuration}",
        "MaxSize": ${max_size},
        "MinSize": ${min_size}
      },
      "UpdatePolicy": {
        "AutoScalingRollingUpdate": {
          "MinInstancesInService": ${min_instances_in_service},
          "MaxBatchSize": ${max_batch_size}
        }
      }
    }
  }
}
