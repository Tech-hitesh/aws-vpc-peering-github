# AWS VPC Peering Mini-Project Report

**Student name:** [Your name]  
**Course / department:** [Your course]  
**Institution:** [Your institution]  
**Project date:** [Date]  
**AWS Region:** Asia Pacific (Sydney), `ap-southeast-2`

## 1. Abstract

This project demonstrates VPC peering between two Amazon Virtual Private Clouds (VPCs) in AWS. The lab includes public and private subnets, a bastion EC2 instance, route-table entries, security groups, and connectivity tests. The peering connection reached the Active state. TCP connectivity from the bastion to the SSH port on both application instances was confirmed, while the ICMP ping test to App-B did not receive replies.

## 2. Objectives

- Create two VPCs and required subnets.
- Configure a public bastion host.
- Create and activate a VPC peering connection.
- Add reciprocal routes to the route tables.
- Configure security groups for the required traffic.
- Test connectivity and document results.

## 3. AWS resources

| Resource | Name / configuration |
|---|---|
| Region | `ap-southeast-2` |
| VPC A | `ewb-vpc-a`, CIDR `28.0.0.0/16` |
| VPC B | `ewb-vpc-b`, CIDR `28.200.0.0/16` |
| Subnets | `ewb-a-public`, `ewb-a-private`, `ewb-b-private` |
| Internet gateway | `ewb-igw-a` |
| Route tables | `ewb-rt-a-public`, `ewb-rt-a-private`, `ewb-rt-b-private` |
| Peering connection | `ewb-a-b-peer` |
| Security groups | `ewb-sg-bastion`, `ewb-sg-app-a`, `ewb-sg-app-b` |
| Bastion operating system | Amazon Linux 2023 |

**CIDR warning:** The lab used `28.0.0.0/16` and `28.200.0.0/16`. These are not RFC 1918 private IPv4 ranges. For a new design, use non-overlapping private ranges such as `10.10.0.0/16` and `10.20.0.0/16`, unless the lab instructions specify otherwise. Do not claim the deployed lab used different CIDRs.

## 4. Architecture

The administrator connects to the public bastion host through SSH. The bastion is in VPC A. App-A is in a private subnet in VPC A, and App-B is in a private subnet in VPC B. VPC peering provides a private routing path between the two VPCs when route tables and security rules allow the traffic.

See `../diagrams/architecture.mmd` and the README architecture diagram.

## 5. Implementation summary

1. Created VPC A and VPC B.
2. Created the public and private subnets.
3. Attached an Internet Gateway to VPC A and configured the public route.
4. Launched the bastion and application EC2 instances.
5. Created the VPC peering connection and verified that its status was Active.
6. Added the reciprocal VPC peering routes to the relevant route tables.
7. Configured security groups for the required SSH and connectivity tests.
8. Connected to the bastion through SSH from the administrator laptop.
9. Ran TCP connectivity tests from the bastion to App-A and App-B on port 22.

## 6. Route-table configuration

- **VPC A public route table:** VPC A local route; default route to the Internet Gateway; route to VPC B via the peering connection.
- **VPC A private route table:** VPC A local route and VPC B route via peering.
- **VPC B private route table:** VPC B local route and VPC A route via peering.

The exact target IDs can be captured from the AWS Console screenshots. Confirm each route is active and each subnet is associated with the intended route table.

## 7. Testing and results

| Test | Observed result | Status |
|---|---|---|
| SSH login to bastion | Shell prompt displayed | Successful |
| VPC peering | Status Active | Successful |
| Bastion to App-A TCP port 22 | Exit code `0` | Successful TCP connection |
| Bastion to App-B TCP port 22 | Exit code `0` | Successful TCP connection |
| Bastion to App-B ICMP ping | 100% packet loss | Not successful |

A TCP connection test confirms that the TCP port was reachable at the time of testing. It does not verify successful SSH authentication. The ping result means ICMP replies were not received; it does not, by itself, establish that peering failed.

## 8. Challenges and troubleshooting

- A placeholder string was initially used instead of App-A's IP address, causing a name-resolution error. Replacing it with the actual private IP resolved that command issue.
- TCP tests were used to distinguish port reachability from ICMP ping behavior.
- The bastion has approximately 913 MiB total RAM and an 8 GB root disk. Installing a full graphical desktop on this small instance may lead to poor performance; the project used SSH for administration.

## 9. Security considerations

- Private keys and credentials must never be included in the repository.
- SSH ingress should be restricted to a trusted source IP.
- Private instances should not be exposed directly to the public internet.
- Security-group rules should allow only required protocols and ports.
- New VPC designs should use non-overlapping RFC 1918 private address ranges.

## 10. Conclusion

The lab established an Active VPC peering connection and configured reciprocal route-table entries. SSH access to the bastion worked, and TCP port 22 was reachable from the bastion to both application instances. ICMP ping to App-B did not receive replies, so ICMP connectivity remains unverified. The exercise provided hands-on practice with VPCs, subnets, route tables, security groups, EC2, and network troubleshooting.

## 11. Evidence checklist

Add redacted screenshots for:

- [ ] VPC A details
- [ ] VPC B details
- [ ] Active peering connection
- [ ] VPC A public route table
- [ ] VPC A private route table
- [ ] VPC B private route table
- [ ] EC2 instances in running state
- [ ] Successful SSH session to bastion
- [ ] TCP port 22 test results
- [ ] ICMP ping result showing packet loss

## 12. References

- AWS VPC Peering Guide: https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html
- Amazon EC2 User Guide: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html
- Amazon Linux 2023 User Guide: https://docs.aws.amazon.com/linux/al2023/ug/
