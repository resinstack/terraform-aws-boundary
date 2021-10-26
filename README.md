# terraform-aws-boundary

This module contains the prerequisite components required to setup
Hashicorp Boundary which includes both the firewall rules to
communicate, and the KMS setup and policy to secure the system.

The controllers are placed into a target group which you may attach to
your load balancing technology of choice.
