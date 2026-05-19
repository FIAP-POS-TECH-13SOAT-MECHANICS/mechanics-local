#!/bin/bash

FUNCTION_NAME='fiap-mechanics-dev-auth-consumer'
QUEUE_NAME='fiap-mechanics-dev-user-changed'

zip -j /tmp/auth-consumer.zip /etc/localstack/init/ready.d/3-auth-consumer.mjs

awslocal lambda create-function \
  --function-name "$FUNCTION_NAME" \
  --runtime nodejs20.x \
  --handler 3-auth-consumer.handler \
  --zip-file fileb:///tmp/auth-consumer.zip \
  --role arn:aws:iam::000000000000:role/irrelevant > /dev/null
echo "Function '$FUNCTION_NAME' created."

QUEUE_URL=$(awslocal sqs get-queue-url --queue-name "$QUEUE_NAME" --query QueueUrl --output text)
QUEUE_ARN=$(awslocal sqs get-queue-attributes \
  --queue-url "$QUEUE_URL" \
  --attribute-names QueueArn \
  --query Attributes.QueueArn --output text)

awslocal lambda create-event-source-mapping \
  --function-name "$FUNCTION_NAME" \
  --event-source-arn "$QUEUE_ARN" \
  --batch-size 10 > /dev/null
echo "Event source mapping '$QUEUE_NAME' -> '$FUNCTION_NAME' created."
