# REDDIT_data_pipeline

## Overview
Reddit DATA PIPELINE: this is basically an ETL (extract, transform, load) process. It is an automated data pipeline that extracts data from Reddit using a python package called PRAW, processes it into a clean CSV format, and loads it into a MySQL database. The project leverages Apache Airflow for task automation and Docker for containerization.

## Objectives
	The main objective is to extract data from Reddit 
		
			- extract data from Reddit subreddits using a customized pyhton script
			- preprocess/tranform the extracted data into a clean usable format 
			- load the extracted data (csv) into the MySql database
## Features

<p align="center">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAaA225dLJvUoZmH6ZpsBUw9DFQNssDa-LTQ&s" width="250" height="200">
  <img src="https://media.licdn.com/dms/image/D5612AQFpyk1RHRQwLQ/article-cover_image-shrink_600_2000/0/1705757924083?e=2147483647&v=beta&t=OnPiaj1_9HQmHrWGOrHvrNFBUPOqdY7t7tY43CJuOgE" width="400" height="200">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFPLXqRyw5PEl4ETnuzYuP5XhUI51sUdQzcg&s" width="200" height="200">
</p>

#### Automated Data Extraction from Reddit
Data Extraction: The project includes a Python script that leverages the praw library (Python Reddit API Wrapper) to extract data from specified subreddits. This script is designed to be customizable, allowing you to specify different subreddits, and types of data (e.g., posts, comments). The script can extract various data points from Reddit, including post titles, content, metadata (such as upvotes and comments), and more. The flexibility of the script allows for easy adaptation to different data needs.

Daily Schedule with Airflow: The extraction process is automated using Apache Airflow, which runs the data extraction script on a daily schedule.

#### Data Preprocessing and Storage
Data Cleaning: After extraction, the raw Reddit data is processed to remove unnecessary information, standardize formats, and handle any missing or incomplete data. This ensures that the data is in a clean and usable format, suitable for further analysis or storage.
The cleaned data is stored in a structured CSV format, making it easy to handle. 
The transformation task is also automated using Airflow.

#### Data Loading into MySQL Database
MySQL Integration: The project integrates with a MySQL database running in a Docker container. This allows the extracted and processed Reddit data to be stored in a relational database, making it easy to query and analyze using SQL.
Automated Data Loading: Once the data is preprocessed and stored as a CSV file, a Bash script is executed to load the data into a MySQL database. This step was initially automated using Airflow, however due to an resolved issue, the task fails to load the data into the database. A quick fix to this issue was to make use of linux  command 'Crontab job' to execute the task at a scheduled time ensuring a seamless ETL (Extract, Transform, Load) process from start to finish.

#### Dockerized Setup for Easy Deployment
The entire project, including the services(Airflow, MySQL) is containerized using Docker. This ensures that the project can be easily deployed on any system that supports Docker, with all dependencies and configurations included inside an extended image. A single docker-compose.yml file defines the setup for Airflow, MySQL, and any other required services, making it easy to start, stop, and manage the project.

A volume was mounted for Persistent Storage this means that even if the containers are stopped or removed, the data (including the extracted Reddit data and Airflow logs) remains intact.
The project is highly configurable via environment variables, which are stored in a .env file. This allows for easy customization of settings such as database credentials, API keys without modifying the code.
