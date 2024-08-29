from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import subprocess

# Default arguments for the Reddit DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Function to execute the reddit extraction script
def reddit_extraction():
    script_path = '/mnt/c/Reddit_Proj/scripts/reddit_extract.py'
    result = subprocess.run(['python3', script_path], check=True, capture_output=True, text=True)
    print(result.stdout)  # Print the standard output
    print(result.stderr)  # Print the error output

# Function to execute the reddit transformation script
def reddit_transformation():
    script_path = '/mnt/c/Reddit_Proj/scripts/transformation_reddit_csv.py'
    subprocess.run(['python3', script_path], check=True)

# Define the DAG
with DAG(
    'Reddit_Project',
    default_args=default_args,
    description='Run daily scripts',
    schedule_interval='0 10 * * *',  # Schedule to run daily at 11:00 AM
    start_date=datetime(2024, 1, 1),
    catchup=False,
) as dag:
    
    # Task 1: reddit_extraction
    extract = PythonOperator(
        task_id='reddit_extraction',
        python_callable=reddit_extraction,
    )

    # Task 2: reddit_transformation
    transform = PythonOperator(
        task_id='reddit_transformation',
        python_callable=reddit_transformation,
    )


   # Set task dependencies
    extract >> transform 