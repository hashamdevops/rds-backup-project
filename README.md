# RDS Backup Script

This project contains a Bash script to automate the backup of an AWS RDS MySQL database. It compresses the dump, uploads it to an S3 bucket, and deletes old backups older than 2 days.

## Prerequisites

- AWS CLI configured with proper permissions
- MySQL client tools installed (`mysqldump`)
- An existing RDS MySQL database
- An S3 bucket created to store backups with 2 days backup
## Setup

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/rds-backup-project.git
   cd rds-backup-project
