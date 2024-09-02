# REDDIT_ETL_PROJECT

## Overview
This project is an ETL (extract, transform, load) process. It is an automated data pipeline that extracts data from Reddit using a python package called PRAW, processes it into a clean CSV format, and loads it into a MySQL database. The project leverages Apache Airflow for task automation and Docker for containerization.

## Objectives
	The main objective is to extract data from Reddit 
		
			- extract data from Reddit subreddits using a customized pyhton script
			- preprocess/tranform the extracted data into a clean usable format 
			- load the extracted data (csv) into the MySql database
## Features

<p align="center">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAaA225dLJvUoZmH6ZpsBUw9DFQNssDa-LTQ&s" width="250" height="200">
  <img src="https://media.licdn.com/dms/image/D5612AQFpyk1RHRQwLQ/article-cover_image-shrink_600_2000/0/1705757924083?e=2147483647&v=beta&t=OnPiaj1_9HQmHrWGOrHvrNFBUPOqdY7t7tY43CJuOgE" width="350" height="200">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFPLXqRyw5PEl4ETnuzYuP5XhUI51sUdQzcg&s" width="200" height="200">
</p>

#### Automated Data Extraction from Reddit
Data Extraction: The project includes a Python script that leverages the praw library (Python Reddit API Wrapper) to extract data from specified subreddits. This script is designed to be customizable, allowing you to specify different subreddits, and types of data (e.g., posts, comments). The script can extract various data points from Reddit, including post titles, content, metadata (such as upvotes and comments), and more. The flexibility of the script allows for easy adaptation to different data needs.

Daily Schedule with Airflow: The extraction process is automated using Apache Airflow, which runs the data extraction script on a daily schedule.

### Data Preprocessing and Storage
Data Cleaning: After extraction, the raw Reddit data is processed to remove unnecessary information, standardize formats, and handle any missing or incomplete data. This ensures that the data is in a clean and usable format, suitable for further analysis or storage.
The cleaned data is stored in a structured CSV format, making it easy to handle. 
The transformation task is also automated using Airflow.

### Data Loading into MySQL Database
MySQL Integration: The project integrates with a MySQL database running in a Docker container. This allows the extracted and processed Reddit data to be stored in a relational database, making it easy to query and analyze using SQL.
Automated Data Loading: Once the data is preprocessed and stored as a CSV file, a Bash script is executed to load the data into a MySQL database. This step was initially automated using Airflow, however due to an resolved issue, the task fails to load the data into the database. A quick fix to this issue was to make use of linux  command 'Crontab job' to execute the task at a scheduled time ensuring a seamless ETL (Extract, Transform, Load) process from start to finish.

### Dockerized Setup for Easy Deployment
The entire project, including the services(Airflow, MySQL) is containerized using Docker. This ensures that the project can be easily deployed on any system that supports Docker, with all dependencies and configurations included inside an extended image. A single docker-compose.yml file defines the setup for Airflow, MySQL, and any other required services, making it easy to start, stop, and manage the project.

A volume was mounted for Persistent Storage this means that even if the containers are stopped or removed, the data (including the extracted Reddit data and Airflow logs) remains intact.
The project is highly configurable via environment variables, which are stored in a .env file. This allows for easy customization of settings such as database credentials, API keys without modifying the code.

## SETUP
I will be giving a detailed explanation on how to run the procject.

### Prerequisites
Before starting, ensure you have the following installed:

Docker Desktop (For Windows/Mac users) or Docker Engine (For Linux users).
Download Docker Desktop
note: if you are using a windows machine, you will have to make use of WSL or a virtual machine (VM)  to be able to use  Dockers. In my case I used WSL, there are many articles online that can be useful in the installation process.

### Step 1: Clone the Repository

### Step 2: Setup Environment Variables
cd <your-repository-directory>
there is a '.env' file however you will have to set 'AIRFLOW__CORE__FERNET_KEY' you can do this with the following code in python:
```
		from cryptography.fernet import Fernet
		key = Fernet.generate_key()
		print(key.decode())
```
replace the value in the .env file with the newly generated key

### Step 3: Build Docker Image: 
cd into the conf directory that contains the Dockerfile, docker-compose.yml and .env file
then run the following command to build up the custom image
```docker-compose build```

### Step 4: Initialize Docker Containers
once it is completed, next would be to Start the Docker Containers using the command

```docker-compose up```
 
 this would start up the services (Airflow & MySQL)

 ### Step 5: Accessing the Airflow Web Interface

Once the services are up and running, you can access the Airflow web interface to monitor your DAGs:

URL: http://localhost:8080
Default Credentials:
Username: airflow
Password: airflow

the name of the DAG is "Reddit_Projec"

### Step 6: Run Your ETL Process
Your DAG should automatically trigger based on the schedule you set. However, you can also trigger it manually from the Airflow web interface.


### NOTE: 
1. it is very important that you check all the paths that have been set in the scripts! It is as a result of the fact that the directories you will use may be different from the ones used in the scripts.
2. you will have to change the credentials in the script 'reddit_extract.py'. this link provides a more detailed explanation on how to go about it
https://lukianovihor.medium.com/data-ingestion-for-reddit-api-part-1-getting-started-with-a-new-data-source-a9e7fc6daf9c
3. I used Dbeaver( a free cross-platform database tool) you will have to connect the MySQL database to Dbeaver or any other database application of your choice. it has a user-friendly interface for executive SQL queries, managing database structure and visualizing data

   
### Directory Structure
Your project directory should look like this:

```
project-directory/Reddit_Proj

│
├── conf/
│   ├── config/
│   ├── dags/
│   	└── ET_Reddit.py		# the python file that contains the dag
│   ├── logs/
│   	├── crontab_log/		# the logs from crontab will be stored here
│  		└── ...
│   ├── plugins/
│   ├── Dockerfile				# contains a series of instructions, It defines the base image and dependencies
│   ├── .env					# contains the creds(AIRFLOW__CORE__FERNET_KEY)
│   └── docker-compose.yml		# configuration file used to define the containers used
│
├── scripts/
│   ├── reddit_extract.py		# python script that will extract data from Reddit using the PRAW library
│   ├── transformation_reddit_csv.py	# python script that will tranform the extracted csv file into a clean usable csv format
│   ├── subreddits.txt			# contains the name of the subreddit groups from which data will be extracted from
│   └── reddit_load.sh			# bash script that will insert or load the processed csv files into MySql database
│
├── data/
│   ├── reddit-comments-2024-08-27.csv		# a sample of the extracted data
│   └── ...
│
└── README.md
```
