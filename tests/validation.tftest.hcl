run "verify_instance_count" {
  command = plan

  assert {
    condition     = length(aws_instance.server) == 2
    error_message = "Expected 2 instances to be provisioned based on the servers local map (nginx and php_fpm)."
  }
}