# 🔐 RDS Backup Utility (Bash + AWS)

This utility automates the backup of an AWS RDS MySQL database. It:

- Creates a database dump using `mysqldump`
- Compresses the backup file
- Uploads it to a specified S3 bucket
- Deletes old backups older than 2 days

---

## ✅ Prerequisites

- ✅ AWS EC2 instance (Amazon Linux or Ubuntu)
- ✅ RDS MySQL database
- ✅ S3 bucket to store the backups
- ✅ IAM Role attached to the EC2 instance with S3 access (see below)
- ✅ MySQL client tools installed (`mysqldump`)
- ✅ AWS CLI installed
