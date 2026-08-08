#!/bin/sh
set -eu

: "${AWS_S3_BUCKET:?AWS_S3_BUCKET is required}"
: "${AWS_CLOUDFRONT_DISTRIBUTION_ID:?AWS_CLOUDFRONT_DISTRIBUTION_ID is required}"

yarn build

echo "Uploading to s3://${AWS_S3_BUCKET}/"
aws s3 sync ./out/ "s3://${AWS_S3_BUCKET}/" \
  --cache-control "public,max-age=300"

# Keep old hashed assets so clients holding cached HTML never lose a chunk
# between upload and invalidation. Remove only explicitly retired public files.
for key in assets/rum-monitoring.js svg/terrastruct.svg; do
  if aws s3api head-object \
    --bucket "${AWS_S3_BUCKET}" \
    --key "${key}" >/dev/null 2>&1; then
    aws s3 rm "s3://${AWS_S3_BUCKET}/${key}"
  fi
done

if [ -d ./out/_next ]; then
  aws s3 cp ./out/_next/ "s3://${AWS_S3_BUCKET}/_next/" \
    --recursive \
    --cache-control "public,max-age=31536000,immutable"
fi

for directory in fonts images favicon; do
  if [ -d "./out/${directory}" ]; then
    aws s3 cp "./out/${directory}/" "s3://${AWS_S3_BUCKET}/${directory}/" \
      --recursive \
      --cache-control "public,max-age=86400"
  fi
done

echo "Invalidating CDN cache..."
aws cloudfront create-invalidation \
  --distribution-id "${AWS_CLOUDFRONT_DISTRIBUTION_ID}" \
  --paths "/*" >/dev/null

echo "Deployment complete!"
