# Bookstore Frontend Deployment to S3 
 
This document describes how to deploy the React frontend to AWS S3 for static hosting. 
 
## Prerequisites 
- AWS CLI installed and configured with appropriate permissions 
- Node.js and npm installed 
 
## Deployment Options 
 
### Option 1: Using npm script 
npm run deploy 
 
### Option 2: Using the deployment batch file 
Run the deploy-s3.bat file in the project root directory: 
deploy-s3.bat 
 
## Environment Configuration 
Make sure your .env file contains the correct API URL for your deployed backend: 
REACT_APP_API_URL=your_elastic_beanstalk_api_url 
