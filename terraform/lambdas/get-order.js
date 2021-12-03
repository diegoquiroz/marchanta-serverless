const pg = require("pg");
const AWS = require("aws-sdk");

const region = "us-east-1";
const client = new AWS.SecretsManager({
  region: region,
});

let pgClient;

exports.handler = async (event, context, callback) => {
  const secretValue = await client.getSecretValue({
    SecretId: process.env.SECRET_NAME,
  }).promise();
  const secretParams = JSON.parse(secretValue.secretString);

  if (!pgClient) {
    const connectionInfo = {
      user: secretParams.username,
      passsword: secretParams.password,
      host: secretParams.host,
      database: "postgres",
      port: secretParams.port,
    };
    pgClient = new pg.Client(connectionInfo);
    await pgClient.connect();
  }

  const query = await pgClient.query("SELECT * order");

  return {
    "isBase64Encoded": false,
    "statusCode": 200,
    "body": JSON.stringify(query.rows),
  };
};
