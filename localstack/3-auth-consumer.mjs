import { DynamoDBClient, PutItemCommand } from '@aws-sdk/client-dynamodb';

const TABLE = 'auth-dev-users';
const client = new DynamoDBClient({
    endpoint: 'http://localhost.localstack.cloud:4566',
    region: 'us-east-1',
    credentials: { accessKeyId: 'test', secretAccessKey: 'test' },
});

export const handler = async (event) => {
    const response = { batchItemFailures: [] };

    for (const record of event.Records) {
        try {
            const msg = JSON.parse(record.body);

            await client.send(new PutItemCommand({
                TableName: TABLE,
                ConditionExpression: 'attribute_not_exists(id) OR lastUpdate < :incoming',
                ExpressionAttributeValues: {
                    ':incoming': { S: msg.LastUpdate },
                },
                Item: {
                    id: { S: msg.Id },
                    cpfNumber: { S: msg.CpfNumber },
                    fullName: { S: msg.FullName },
                    role: { S: msg.Role },
                    securityStamp: { S: msg.SecurityStamp },
                    passwordHash: { S: msg.PasswordHash },
                    lastUpdate: { S: msg.LastUpdate },
                    customerId: msg.CustomerId
                        ? { S: msg.CustomerId }
                        : { NULL: true },
                },
            }));
        } catch (err) {
            if (err.name === 'ConditionalCheckFailedException') {
                console.warn(`User already up-to-date, skipping: ${record.messageId}`);
            } else {
                console.error(`Failed: ${record.messageId}`, err);
                response.batchItemFailures.push({ itemIdentifier: record.messageId });
            }
        }
    }

    return response;
};
