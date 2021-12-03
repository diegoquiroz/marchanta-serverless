const pg = require("pg");

exports.handler = async (event, context, callback) => {
  const env = process.env;

  const config = {
    user: env.DB_USER,
    passsword: env.DB_PASS,
    host: env.DB_HOST,
    database: env.DB_NAME,
    port: env.DB_PORT,
  };

  const pool = new pg.Pool(config);

  let data = event.body;

  const query =
    `INSERT INTO order VALUES ${}`;
  const queryResponse = await db.query(query);

  db = await pool.connect();


  return {
    "isBase64Encoded": false,
    "statusCode": 200,
    "body": JSON.stringify(query.rows ? query.rows : undefined),
  };
};
