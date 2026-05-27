action "aws_ec2_stop_instance" "force_stop" {
  for_each = aws_instance.instances

  config {
    instance_id = each.value.id
    force       = true
    timeout     = 300
  }
}
