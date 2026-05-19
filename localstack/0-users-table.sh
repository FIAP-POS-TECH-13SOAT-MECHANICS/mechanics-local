#!/bin/bash

TABLE="auth-dev-users"
awslocal dynamodb create-table \
  --table-name "$TABLE" \
  --attribute-definitions \
    AttributeName=id,AttributeType=S \
    AttributeName=cpfNumber,AttributeType=S \
  --key-schema AttributeName=id,KeyType=HASH \
  --global-secondary-indexes '[
    {
      "IndexName": "cpfNumber-index",
      "KeySchema": [{"AttributeName": "cpfNumber", "KeyType": "HASH"}],
      "Projection": {"ProjectionType": "ALL"}
    }
  ]' \
  --billing-mode PAY_PER_REQUEST > /dev/null
echo "Table '$TABLE' created."
