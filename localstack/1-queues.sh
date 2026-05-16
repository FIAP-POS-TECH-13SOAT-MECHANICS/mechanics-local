#!/bin/bash

QUEUES=(
  "fiap-mechanics-dev-customer-created"
  "fiap-mechanics-dev-user-changed"
  "fiap-mechanics-dev-work-order-created"
  "fiap-mechanics-dev-work-order-status-changed"
  "fiap-mechanics-dev-budget-created"
  "fiap-mechanics-dev-budget-revised"
  "fiap-mechanics-dev-payment-approved"
)

for QUEUE in "${QUEUES[@]}"; do
  awslocal sqs create-queue --queue-name "$QUEUE"
done
