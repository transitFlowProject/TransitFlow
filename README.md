<h2 align="center">TransitFlow</h2>
<h3 align="center">Real Time Public Transportation Optimisation</h3>

## Overview

> [!NOTE]
> This repository contains an academic project designed to enhance our skills in Data Engineering. It covering the key steps to go from raw data to a live web app. This project is designed to optimize public transport by identifying delays in bus schedules in real-time. It leverages a sophisticated data pipeline to process and analyze bus operation data, aiming to enhance the reliability and efficiency of public transport services.

This project establishes a data pipeline using Google Cloud Services, orchestrated with Prefect, and delivers real-time insights through a Streamlit web application. It is a showcase for data professionals to create and manage an end-to-end data workflow.

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
