const express = require('express');
const cors = require('cors');
const stripe = require('stripe')('sk_test_51RpuwXQ1idx4nAgVM5ATMgZb1hLtFMfhnSGz45djWQU5AfvKsEThMo8SFdDbTOaRjYJ23bienY18UV5HvKWA7l5G00zjjz15Ok');

const app = express();
app.use(cors());
app.use(express.json());

app.post('/create-checkout-session', async (req, res) => {
  try {
    const { amount, currency } = req.body;

    // Validación básica de monto
    if (!amount || amount <= 0) {
      return res.status(400).json({ error: 'Monto inválido' });
    }

    // Crear sesión de pago en Stripe usando el monto y moneda enviados
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      mode: 'payment',
      line_items: [
        {
          price_data: {
            currency: currency || 'usd',
            product_data: { name: 'Pago desde Flutter' },
            unit_amount: amount, // Monto en centavos (int)
          },
          quantity: 1,
        },
      ],
      success_url: 'https://example.com/success', // Cambia a tu URL de éxito real
      cancel_url: 'https://example.com/cancel',   // Cambia a tu URL de cancelación real
    });

    res.json({ url: session.url });
  } catch (error) {
    console.error('Error creando sesión de Stripe:', error);
    res.status(500).json({ error: error.message });
  }
});

app.listen(3000, () => console.log('Servidor Stripe corriendo en http://localhost:3000'));
