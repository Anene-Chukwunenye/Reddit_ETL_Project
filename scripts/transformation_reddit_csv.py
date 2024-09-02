import os
import pandas as pd
import csv

# Define the directory containing the CSV files
csv_directory = './Reddit_Proj/data'
# Define the expected columns
expected_columns = [
    'comment_id', 'comment_author', 'comment_created_time', 'commentnum_upvotes', 'comment_text',
    'submission_id', 'submission_author', 'submission_title', 'submission_created_time', 'submission_name',
    'submission_num_comments', 'submission_num_upvotes', 'submission_text', 'submission_url', 'subreddit_full_name',
    'subreddit_display_name', 'subreddit_created_utc',
    'subreddit_subscribers', 'subreddit_lang', 'subreddit_subreddit_type', 'subreddit_over18'
]

def preprocess_csv(file_path):
    # Read the CSV file with error handling for extra columns
    df = pd.read_csv(file_path, quoting=csv.QUOTE_ALL, on_bad_lines='warn', dtype=str)
    
    # Ensure the DataFrame has the correct columns
    for column in expected_columns:
        if column not in df.columns:
            df[column] = ''  # Fill missing columns with empty strings

    # Reorder columns to match the expected format
    df = df[expected_columns]

    # Save the preprocessed CSV back to file
    df.to_csv(file_path, index=False, quoting=csv.QUOTE_ALL)

def main():
    # Process each CSV file in the directory
    for file_name in os.listdir(csv_directory):
        if file_name.endswith('.csv'):
            file_path = os.path.join(csv_directory, file_name)
            preprocess_csv(file_path)
            print(f"Preprocessed {file_name}")

if __name__ == '__main__':
    main()
