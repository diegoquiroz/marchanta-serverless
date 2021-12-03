const pg = require("pg");

exports.handler = async (event, context, callback) => {
  const env = process.env;

  const config = {
    user: env.DB_USER,
    password: env.DB_PASS,
    host: env.DB_HOST,
    database: env.DB_NAME,
    port: env.DB_PORT,
  };

  const pool = new pg.Pool(config);

  const clientId = event.clientId;
  const currencyId = event.currencyId;
  const paymentMethodId = event.paymentMethodId;
  const statusId = event.statusId;
  const isArchived = event.isArchived;
  const shippingFee = event.shippingFee;
  const subtotal = event.subtotal;
  const total = event.total;

  const fields =
    "client_id, subtotal, shipping_fee, total, status_id, payment_method_id, currency_id, is_archived, created_on";
  const values =
    `${clientId}, ${subtotal}, ${shippingFee}, ${total}, ${statusId}, ${paymentMethodId}, ${currencyId}, ${isArchived}, to_timestamp(${Date.now()} / 1000.0)`;

  const query = `INSERT INTO orders.order (${fields}) VALUES (${values})`;

  let db = await pool.connect();
  const queryResponse = await db.query(query);

  return {
    "isBase64Encoded": false,
    "statusCode": 200,
    "body": JSON.stringify(query.rows ? query.rows : undefined),
  };
};
