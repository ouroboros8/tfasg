Notes
======

Using a template file (`data.template_file`) to render cloudformation decouples
the `aws_cloudformation_stack` dependencies on resources used in the template
(e.g. `aws_launch_configuration`). This can be fixed with manual `depends_on` or
by interpolating the variables inline with, for example, heredoc syntax.

Notes on MinSize/MaxSize/MinInstancesInService: Min and Max Size can be the
same, but MinInstancesInService must be lower than MaxSize.
MinInstancesInService is effectively an override to MinSize during the rolling
upgrade; if it is equal to MaxSize, the upgrade can neither create new instances
(because it would exceed MaxSize in doing so), nor terminate old instances
(because it would dip below MinInstancesInService).
