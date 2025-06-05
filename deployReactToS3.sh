#!/bin/bash

# This script deploys a React application to an S3 bucket and optionally
# invalidates the CloudFront cache.
#
# Usage:
#   ./deploy.sh            (deploys to S3)
#   ./deploy.sh clear      (deploys to S3 and invalidates CloudFront cache)

# Make sure to change the S3 bucket and distribution-ID associated with your deployment

# Check if an argument is provided for clearing the cache
clear_cache="$1"

echo "Deleting contents of S3 bucket"
aws s3 rm --recursive s3://example-bucket-12345665874

echo "Copying build files to S3 bucket"
aws s3 cp --recursive ./react/dist/ s3://example-bucket-12345665874

# Check if the 'clear' argument was provided
if [ -n "$clear_cache" ]; then
    echo "Invalidating CloudFront"
    
    aws cloudfront create-invalidation --distribution-id E3HC8GGWTS8BMM --paths "/*"
else
    echo "Skipping CloudFront invalidation."
fi

echo "Deployment script finished."