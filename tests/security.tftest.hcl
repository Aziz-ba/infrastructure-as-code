variables {
  allowed_ssh_cidr = "1.2.3.4/32"
}

run "verify_ssh_access" {
  command = plan

  assert {
    condition     = aws_security_group.web.ingress[1].cidr_blocks[0] == "1.2.3.4/32"
    error_message = "The security group must restrict SSH access to the provided CIDR block."
  }
}