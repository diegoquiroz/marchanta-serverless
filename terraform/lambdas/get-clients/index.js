const pg = require("pg");

let pgClient;

exports.handler = async (event, context, callback) => {
  const env = process.env;

  if (!pgClient) {
    const connectionInfo = {
      user: env.DB_USER,
      password: env.DB_PASS,
      host: env.DB_HOST,
      database: env.DB_NAME,
      port: env.DB_PORT,
    };
    pgClient = new pg.Client(connectionInfo);
    await pgClient.connect();
  }

  const query = await pgClient.query("SELECT * FROM orders.client");

  return {
    "isBase64Encoded": false,
    "statusCode": 200,
    "body": JSON.stringify(query.rows ? query.rows : undefined),
  };
};
