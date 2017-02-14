Notes
======

Using a template file (`data.template_file`) to render cloudformation decouples
the `aws_cloudformation_stack` dependencies on resources used in the template
(e.g. `aws_launch_configuration`). This can be fixed with manual `depends_on` or
by interpolating the variables inline with, for example, heredoc syntax.
