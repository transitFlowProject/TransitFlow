<h2 align="center">TransitFlow</h2>
<h3 align="center">Real Time Public Transportation Optimisation</h3>

## Overview    

> [!NOTE]
> This repository contains an academic project designed to enhance our skills in Data Engineering. It covering the key steps to go from raw data to a live web app. This project is designed to optimize public transport by identifying delays in bus schedules in real-time. It leverages a sophisticated data pipeline to process and analyze bus operation data, aiming to enhance the reliability and efficiency of public transport services.

> [!IMPORTANT] 
> This project establishes a data pipeline using Google Cloud Services, orchestrated with Prefect, and delivers real-time insights through a Streamlit web application. It is a showcase for data professionals to create and manage an end-to-end data workflow.

## Important Links & Live Demo 🚀

- [Data Source](https://data.bus-data.dft.gov.uk/)
- [Streamlit App](#) currently under construction 🔨

## Infrastructure

### Tools & Services

![cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=flat-square&logo=googlecloud&logoColor=white) ![terraform](https://img.shields.io/badge/Terraform-844FBA?style=flat-square&logo=terraform&logoColor=white) ![docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white) ![prefect](https://img.shields.io/badge/-Prefect-070E10?style=flat-square&logo=prefect) ![streamlit](https://img.shields.io/badge/Streamlit-FF4B4B?style=flat-square&logo=streamlit&logoColor=white)

### Databases

![bigquery](https://img.shields.io/badge/BigQuery-669DF6?style=flat-square&logo=googlebigquery&logoColor=white)

## Data and CI/CD Pipeline

##### The initial version

![data-pipeline](https://storage.googleapis.com/bus_tracker_files/init_architecture.png)

The architecture is designed to process data in real time, starting from data extraction from the Bus Open Data Service to the final deployment using Streamlit for data visualization. Key components include:

1. Raw data ingestion: Real-time data collection.
2. Data transformation: Uses Prefect to orchestrate data transformation tasks, cleans and prepares data for analysis.
3. Data storage: Stores transformed data in BigQuery.
4. Deployment with Docker and Cloud Run: Pack the services into Docker containers and deploy them on Cloud Run.
5. User interface with Streamlit: Creation of a user interface with Streamlit to visualize data in real time.
6. Automation with Terraform: Use Terraform to provision and manage the resources needed on GCP.



# Steps

## Deploy GCP infrastructures with terraform

- [terraform.tfvars](https://github.com/transitFlowProject/TransitFlow/blob/8b26174bacbdc3365fc385a1e0e89d411160885b/terraform/terraform/terraform.tfvars): For this project we creat the storage bucket and artifact registry with Terraform. The Compute Engine and BigQuery configuration are created with prefect script.

For our storage bucket below, we define its name and region. 

![ A GCS stores our raw data](https://github.com/transitFlowProject/TransitFlow/blob/8b26174bacbdc3365fc385a1e0e89d411160885b/Public/Public/Images/bucket.png)


And for our artifact registry we define its ID, region and format (Docker in our case).
![artifact registry](https://github.com/transitFlowProject/TransitFlow/blob/3f21d7c35554258423f4370ba6d875179888ac3f/Public/Public/Images/artifact_registry_dockerImage.png)


## Creating prefect blocks

We first start by creating our prefect blocks that allow us to store configuration data to interact with external systems (authenticating with GCP, interacting with a bucket..), we can use these blocks by calling them in our python scripts (see below). 

![Prefect blocks](https://github.com/transitFlowProject/TransitFlow/blob/dde07f10f782005cfcf776d3d2900ae0cf98a338/Public/Public/Images/creat_prefect_blocks.png)

## Running the ETL scripts 
- [bus_live_locations.py](https://github.com/transitFlowProject/TransitFlow/blob/1644646cd21fe61d5513d76f28e137412629506c/ETL/bus_live_locations.py) : Pulls the live bus locations from the Open Bus Data GTFS feed for the area specified by the bounding box coordinates. The data is saved as a parquet file and uploaded to the Google storage bucket.

- [bus_timetables.py](https://github.com/transitFlowProject/TransitFlow/blob/1644646cd21fe61d5513d76f28e137412629506c/ETL/bus_timetables.py): Gets the latest bus timetable GTFS data for the relevant region, transforms it and loads the parquet file to the bucket.

- [compare_bus_times.py](https://github.com/transitFlowProject/TransitFlow/blob/1644646cd21fe61d5513d76f28e137412629506c/ETL/compare_bus_times.py): Gets the bus live location and timetable files from the bucket, transforms them and calculates which buses are currently late to arrive at their next bus stop. The output is a small csv file containing a list of late buses and their associated trip information. The csv is uploaded to the bucket.

- [write_to_bq.py](https://github.com/transitFlowProject/TransitFlow/blob/1644646cd21fe61d5513d76f28e137412629506c/ETL/write_to_bq.py): Gets the late bus csv file and appends the data to our BigQuery table.

- [create_bq_table.py](https://github.com/transitFlowProject/TransitFlow/blob/1644646cd21fe61d5513d76f28e137412629506c/ETL/create_bq_table.py) : Creates the BigQuery table with mentioned columns

- [master_flow.py](https://github.com/transitFlowProject/TransitFlow/blob/1644646cd21fe61d5513d76f28e137412629506c/ETL/master_flow.py) : Runs the entire flow and shows it on Prefect UI.

## Execution ETL flow on Prefect
![ETL flow execution with Prefect](https://github.com/transitFlowProject/TransitFlow/blob/e01e46db37d70848a63d4ffcb9fffbae118e03b3/Public/Public/Images/exucution_ETL_flow.png)

## Creat the deployments flow 

![Created the deployments to manage flow scheduling](https://github.com/transitFlowProject/TransitFlow/blob/0bf195e368d1e7e0137005d9cc6b17371426d861/Public/Public/Images/Prefect_deployement_flow.png)

## Store transformed data in BigQuery

![a big query table contains late buses data](https://github.com/transitFlowProject/TransitFlow/blob/20d82da43f3f4c438d8f6736939bee004bf04a7d/Public/Public/Images/big_query_recorded_data.png)

##  Creating the execution environment with Docker 🐋  and Cloud Run  ☁️

This process involves creating a Docker image, pushing it to Google Artifact Registry, and deploying a Prefect Cloud Run Job for our data pipeline scripts. This setup allows for easy updates from GitHub without rebuilding the Docker image.

- [Dockerfile](https://github.com/transitFlowProject/TransitFlow/blob/651f6937ab112510032e278817ad79197c3ca28b/Dockerfile) :Dockerfile content (to install Python and project packages)

#### Authenticate Docker with Artifact Registry
``` bash
$ gcloud auth configure-docker europe-west3-docker.pkg.dev
```

#### Build Docker Image
``` bash
$ docker build -t transitflow:v1 
```

#### Tag the Docker Image

``` bash
$ docker tag transitflow:v1 europe-west3-docker.pkg.dev/transitflow-407821/bus-tracking-docker/transitflow:v1
```
#### Push Docker Image to Artifact Registry
``` bash
$ docker push europe-west3-docker.pkg.dev/transitflow-407821/bus-tracking-docker/transitflow:v1
```

#### Deploy Cloud Run Job using Prefect
``` bash
prefect deployment build master_flow.py:master_flow -n master__flow -sb github/bus-tracker -ib cloud-run-job/bus-tracker-cloudrun -o prefect-master-flow-deployment --apply

```


## Running Prefect agent on Google Compute Engine

Create a GCP Compute Engine instance using the provided script (change args values) :
- [create_vm.sh](https://github.com/transitFlowProject/TransitFlow/blob/dd0f2115cddf4c74b96f5282e0db85ab7e2a506c/scripts/create_vm.sh)

  
> [!NOTE]
> Use the direct SSH connection button in the console (as showned below)

  ![](https://github.com/transitFlowProject/TransitFlow/blob/25d9a11d61c6eb3061668ad02e85d296125e47ef/Public/Public/Images/prefect_agent.png)

#### Create a new shell script to install the required packages
- [install_script.sh](https://github.com/transitFlowProject/TransitFlow/blob/25d9a11d61c6eb3061668ad02e85d296125e47ef/scripts/install_script.sh) :we need to install Python and Prefect, then log in to Prefect with our Prefect API key.and next execute the script:

```bash
./install_script.sh
```

#### Start the agent 
Use tmux to keep the agent running after killing the SSH connection.

```bash
tmux
prefect agent start -q default
```

##  Deploying the App on Streamlit Cloud

[app.py](https://github.com/transitFlowProject/TransitFlow/blob/48e150db627e7dd112c08ba5c5755f614805e639/streamlit/app.py):Deploying the app on Streamlit Cloud is a straightforward process. Here's a high-level overview:

#### 1. Point the Service to Your GitHub Repository:

In Streamlit Cloud, provide the link to your app code on GitHub.
#### 2. Click Deploy:

Once Streamlit Cloud is linked to your GitHub repository, click the deploy button.
#### 3. Access the Live App:

Streamlit Cloud will build and deploy your app automatically. You can access the live app through the provided URL.


> [!IMPORTANT] 
> the streamlit app is no longer live  since this project is deployed with  GCP free trial






