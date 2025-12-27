const functions = require("firebase-functions/v2/https");
const stripeLib = require("stripe");
const {onRequest} = functions;
const {defineSecret} = require("firebase-functions/params");

// 🔒 load Stripe secret
const STRIPE_SECRET_KEY = defineSecret("STRIPE_SECRET_KEY");

/**
 * ------------------------------------------------------------------
 * 1) CREATE PAYMENT INTENT
 * - Creates PI IN the connected account (direct charge)
 * - Connected account will pay Stripe fees
 * - Platform takes application_fee_amount
 * ------------------------------------------------------------------
 */
exports.createPaymentIntent = onRequest(
    {
      region: "us-central1",
      secrets: [STRIPE_SECRET_KEY],
    },
    async (req, res) => {
      if (req.method !== "POST") {
        return res.status(405).send({error: "Use POST"});
      }

      const {
        amount,
        currency,
        address,
        city,
        state,
        zip,
        name,
        phone,
        fee,
        destinationAccountId, // 👈 the retailer's Stripe acct
      } = req.body;

      if (!amount || !destinationAccountId) {
        return res
            .status(400)
            .send({error: "amount and destinationAccountId are required"});
      }

      const stripe = stripeLib(STRIPE_SECRET_KEY.value());

      try {
        console.log("📥 createPaymentIntent request:", req.body);

        // ✅ DIRECT CHARGE (NO transfer_data, NO on_behalf_of)
        const paymentIntent = await stripe.paymentIntents.create(
            {
              amount: parseInt(amount),
              currency: currency || "usd",
              capture_method: "manual", // keep like you had it
              payment_method_types: ["card"],
              application_fee_amount: parseInt(fee) || 0,
              shipping: {
                name: name || "",
                phone: phone || "",
                address: {
                  line1: address || "",
                  city: city || "",
                  state: state || "",
                  postal_code: zip || "",
                },
              },
            },
            {
              // 👇 THIS is what puts the PI in the CONNECTED ACCOUNT
              stripeAccount: destinationAccountId,
            },
        );

        console.log("✅ PI created in connected acct:", paymentIntent.id);
        return res.status(200).send(paymentIntent);
      } catch (err) {
        console.error("❌ createPaymentIntent error:", err);
        return res.status(500).send({error: err.message});
      }
    },
);

/**
 * ------------------------------------------------------------------
 * 2) CONFIRM PAYMENT INTENT
 * - Confirms the PI INSIDE the same connected account
 * - This is what your Flutter used to do on the client
 * - Now we're moving it server-side so we stay in the right account
 * ------------------------------------------------------------------
 */
exports.confirmPaymentIntent = onRequest(
    {
      region: "us-central1",
      secrets: [STRIPE_SECRET_KEY],
    },
    async (req, res) => {
      if (req.method !== "POST") {
        return res.status(405).send({error: "Use POST"});
      }

      const {
        paymentIntentId, // e.g. "pi_3SOrAf1444PDM8xA0Kd6JVRr"
        paymentMethodId, // e.g. "pm_1...", created in Flutter
        destinationAccountId, // same retailer acct as above
      } = req.body;

      if (!paymentIntentId || !paymentMethodId || !destinationAccountId) {
        return res.status(400).send({
          error: "piId, pmId, and destinationAccountId are required",
        });
      }

      const stripe = stripeLib(STRIPE_SECRET_KEY.value());

      try {
        console.log("📥 confirmPaymentIntent request:", req.body);

        // ✅ confirm inside CONNECTED ACCOUNT
        const confirmed = await stripe.paymentIntents.confirm(
            paymentIntentId,
            {
              payment_method: paymentMethodId,
            },
            {
              stripeAccount: destinationAccountId,
            },
        );

        console.log("✅ PI confirmed:", confirmed.id, confirmed.status);
        return res.status(200).send(confirmed);
      } catch (err) {
        console.error("❌ confirmPaymentIntent error:", err);
        return res.status(500).send({error: err.message});
      }
    },
);

/**
 * (optional, for later)
 * 3) CAPTURE PAYMENT INTENT
 * - only needed because you set capture_method: "manual"
 * - call this AFTER confirm, when you want to finalize
 */
// exports.capturePaymentIntent = onRequest(
//   {
//     region: "us-central1",
//     secrets: [STRIPE_SECRET_KEY],
//   },
//   async (req, res) => {
//     const { paymentIntentId, destinationAccountId } = req.body;
//     const stripe = stripeLib(STRIPE_SECRET_KEY.value());
//     try {
//       const captured = await stripe.paymentIntents.capture(
//         paymentIntentId,
//         {},
//         { stripeAccount: destinationAccountId }
//       );
//       return res.status(200).send(captured);
//     } catch (err) {
//       return res.status(500).send({ error: err.message });
//     }
//   }
// );
