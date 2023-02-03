# Cloud Autoscaling WepApp on Alibaba Cloud high availability, auto-scaling, .

ASAS_Project 

Overview
 
This infrastrucur provides the following benefits
Auto Scaling adjusts the number of ECS instances to ensure optimal performance at minimized costs.  
 ECS instances are deployed across two zones to ensure high application availability. 
 Data caching is provided by an ApsaraDB for Redis instance in a multi-zone deployment.  

Required products
ASAS Project  requires the following Alibaba Cloud products: 
- Elastic Compute Service (ECS) 
 -Virtual Private Cloud (VPC) 
 -Elastic IP Address (EIP) 
 -Server Load Balancer (SLB) 
 -Auto Scaling (ESS) 
 -ApsaraDB for Redis 
 -ApsaraDB  RDS 
  

PROCEDURE SUMMARY 
I- Set up Project infrastructure  
     In this step, we will set up a website on ECS instances.  Specifically, we will perform the following steps: 
1. Create a VPC and two VSwitches. 
2. Create a security group.  
3. Create two EIPs. 
4. Set up an ApsaraDB for Redis instance. 
5. Set up an ApsaraDB RDS instance. 
6. Create an ECS instance.  
7. Install WordPress on the ECS instance. 
8. Create an SLB instance and add the ECS instance as a backend server. 
9. Set up auto scaling.
-II-Simulate fluctuating traffic 
 After Completion we can do this step, we will simulate a traffic spike to trigger a scale-out event and simulate a traffic drop to trigger a scale-in event. 

