#!/bin/bash

# Define MySQL credentials and container name
USER="root"
PASSWORD="reddit"
DATABASE="reddit"
TABLE="main1"
HOST="127.0.0.1"  # Use localhost or 127.0.0.1 for host
PORT="3307"       # Port mapping from the Docker container to host
CONTAINER="mysql_reddit"  # Define MySQL container name
SECURE_FILE_PRIV_DIR="/var/lib/mysql-files/"  # Path inside MySQL container
CSV_SOURCE_DIR="/mnt/c/Reddit_Proj/data"  # Directory containing the CSV files

# Log the start time and initial details
echo "Starting the load script at $(date)"
echo "MySQL Host: $HOST"
echo "Database: $DATABASE"
echo "Table: $TABLE"
echo "CSV Source Directory: $CSV_SOURCE_DIR"
echo "Secure File Priv Directory: $SECURE_FILE_PRIV_DIR"

# Ensure CSV files are in the secure_file_priv directory
echo "Copying CSV files to the secure_file_priv directory..."
for f in "$CSV_SOURCE_DIR"/*.csv
do
  echo "Copying file: $f"
  docker cp "$f" "$CONTAINER":"$SECURE_FILE_PRIV_DIR/"
  if [ $? -eq 0 ]; then
    echo "Successfully copied $f to $SECURE_FILE_PRIV_DIR"
  else
    echo "Error copying $f to $SECURE_FILE_PRIV_DIR" >&2
  fi
done

# Truncate the table before loading new data
echo "Truncating table $TABLE before loading new data..."
mysql -h "$HOST" -P "$PORT" -u "$USER" --password="$PASSWORD" "$DATABASE" -e "
TRUNCATE TABLE $TABLE;
"

# Loop through all CSV files in the secure_file_priv directory
for f in "$CSV_SOURCE_DIR"/*.csv
do
  # Extract the filename from the full path
  filename=$(basename "$f")
  echo "Processing file: $filename"

  # Run the MySQL load data command inside the Docker container
  echo "Running MySQL load data command for $filename"
  mysql -h "$HOST" -P "$PORT" -u "$USER" --password="$PASSWORD" "$DATABASE" -e "
  LOAD DATA INFILE '$SECURE_FILE_PRIV_DIR/$filename'
  INTO TABLE $TABLE
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '\"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  (comment_id, comment_author, comment_created_time, commentnum_upvotes, comment_text,
   submission_id, submission_author, submission_title, submission_created_time, submission_name,
   submission_num_comments, submission_num_upvotes, submission_text, submission_url, subreddit_full_name,
   subreddit_display_name, subreddit_created_utc,
   subreddit_subscribers, subreddit_lang, subreddit_subreddit_type, subreddit_over18);
  "

  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Successfully loaded $filename"
  else
    echo "Error loading $filename" >&2
  fi
done

# Log the end time
echo "Load script completed at $(date)"
