# Cloud Autoscaling WepApp on Alibaba Cloud high availability, auto-scaling, .

ASAS_Project 

Overview
For our online businesses, traffic fluctuations are unavoidable and may occur at both predictable and unexpected times. In order to provide a service that is consistently high performance with minimized cost and effort, it is crucial to deploy an architecture that automatically scales in response to traffic volume changes.

This solution allows us  to automatically adjust the compute capacity in response to traffic fluctuations; helps us  maintain a fine balance between performance and cost using scaling rules; provides high availability and fault tolerance by evenly distributing ECS instances across zones as the compute capacity is scaled; supports database scaling to meet increased data demands; and supports Redis caching across zones to ease the load on the database
Goals
BUILDING AN AUTO  SCALING SYSTEM  ON ALIBABA CLOUD FOR WEB AND APP SYSTEM

ABOUT THIS SOLUTION 
Business need 
For our online businesse, traffic fluctuations are unavoidable and may 
occur at both predictable and unexpected times.  Our ASAS Project will expect hgith traffic during week-end and vacation  , while an unexpected time can rapidly generate large 
amounts of traffic beyond our expectation. In order to provide a service that is consistently high performance with minimized cost and effort, it is crucial to deploy an architecture that automatically scales in response to traffic volume changes. 
Our solution 
as Alibaba Cloud allows us to deploy our application on an auto 
scaling architecture, which automatically adjusts the compute capacity based on actual demand without affecting the application performance. 

 


Benefits 
This solution provides the following benefits
Auto Scaling adjusts the number of ECS instances to ensure optimal performance at minimized costs.  
 ECS instances are deployed across two zones to ensure high application availability. 
 Data caching is provided by an ApsaraDB for Redis instance in a multi-zone deployment.  

 Automatically adjusts the compute capacity in response to traffic fluctuations. 
 Maintains a fine balance between performance and cost using scaling rules. 
 Provides high availability and fault tolerance by evenly distributing ECS instances across zones as the compute capacity is scaled. 
 Supports database scaling to meet increased data demands. 
 Supports Redis caching across zones to ease the load on the 
database. 

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
     In this step, we will set up a website on ECS instances.  Specifically, you will perform the following steps: 
1. Create a VPC and two VSwitches. 
2. Create a security group.  
3. Create two EIPs. 
4. Set up an ApsaraDB for Redis instance. 
5. Set up an ApsaraDB RDA instance. 
6. Create an ECS instance.  
7. Install WordPress on the ECS instance. 
8. Create an SLB instance and add the ECS instance as a backend server. 
9. Set up auto scaling.
-II-Simulate fluctuating traffic 
 After Completion we can do this step, we will simulate a traffic spike to trigger a scale-out event and simulate a traffic drop to trigger a scale-in event. 

---
### Project URL
---
### Architecture Overview

---
### Index
- Deployment
  
  - [Step 1: Install Apache HTTP Server and PHP on ECS]
  - [Step 2: Install and configure Wordpress on ECS]
  - [Step 3: Configure Redis caching]
  - [Step 4: Make custom ECS image for auto scaling](
  - [Step 5: Setup Auto Scaling (ESS) for ECS auto scaling]  
  - [Step 6 (Optional): Simulate fluctuating traffic to trigger auto scaling]
---