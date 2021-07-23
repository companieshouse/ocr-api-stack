# ocr-api-stack

Infrastructure for the OCR Service stack.

This consists of one or more ECS Clusters. Each Cluster has a ELB with one microservice (`ocr-api`) and a CloudWatch dashboard

## Performance Variables

These are configured in the profile environmental vars files (no defaults set):

|     Variable                     | Destroy | Description                                                                       |
|---                               |--- |---                                                                                |
| `ec2_instance_type`              | Y | See [AWS Instance Types)[https://aws.amazon.com/ec2/instance-types/]              |
| `number_of_tasks`                | ? | The number of instances of the `ocr-api` task to run                                |
| `machine_cpu_count`              | ? | The number of vCPUs the `ocr-api` uses.                                             |
| `machine_amount_of_memory_mib`   | ? | The amount of memory in MiB to allocate to the `ocr-api`.                                  |
| `ocr_tesseract_thread_pool_size` | N | The number of threads used in the `ocr-api` application for Tesseract processing (Image to text) |
| `ocr_queue_capacity`             | N | The capacity of the queue used in the `ocr-api` application for Tesseract processing (Image to text) |

- The **"Destroy"** column signifies that the environment should first be destroyed before applying this change to the environment (the main problem seems to be when we change to a more powerful environment),
- If you create a cluster with **more than two tasks,** only two tasks will be running after creation,
- **Make sure that the CPU and Memory values are in the range of the ec2_instance_type.**  The instance type might define the overall memory and CPU in the cluster - Need to confirm (getting inconsistent results). When these do NOT match, the plan will be made and applied but fail in deployment with no clear error messages.

## Internal / external naming

Notes on the internal / external naming:

- internal = DNS names within the AWS cluster that are only used for traffic within (internal to) the environment
- external = DNS names exposing specific services to users outside (external to) the cluster e.g. other CH services, testers etc
- so its not a public/private thing its how functionality/services are used - within the cluster is internal DNS, outside users require the external address.

## Secrets

No secrets are required in this application stack

## Dashboard

The `ocr-api` dashboard is created originally manually using the parent1 environment and then it is exported to the file `groups/stack/module-cloudwatch/dashboard.tmpl` and the following transformations made:

- `app/ocr-api-parent1-lb/15c21529930662af` -> `${elb_arn_suffix}` (example `"app/ocr-api-parent1-lb/15c21529930662af"`-> "${elb_arn_suffix}")
- `parent1` -> `${environment}`  (example `"query": "SOURCE '/ecs/ocr-api-parent1/ocr-api'` -> `"query": "SOURCE '/ecs/ocr-api-${environment}/ocr-api'`)
- `platform**` -> `${environment}**`

The "Golden ruLe" when doing the above is that every widget with data in the Dashboard should have at lease one transformation performed.

The dashboard is made from CloudWatch logs and "metric filter" and metrics (such as the ELB Errors, CPU Utilization).

The logs and metric filter based dashboard widgets are dependent on events emitted from the [ocr-api](https://github.com/companieshouse/ocr-api) microservice.
