import makeWASocket, { useMultiFileAuthState, DisconnectReason, Browsers } from '@whiskeysockets/baileys';
import express from 'express';
import pino from 'pino';
import readline from 'readline';

const app = express();
app.use(express.json());

let sock;
const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
const question = (text) => new Promise((resolve) => rl.question(text, resolve));

async function connectToWhatsApp() {
    const { state, saveCreds } = await useMultiFileAuthState('auth_info_baileys');

    let cleanedNumber = null;
    if (!state.creds.registered) {
        const phoneNumber = await question('\n📱 Enter your WhatsApp Phone Number (with country code, e.g. 919876543210): ');
        cleanedNumber = phoneNumber.replace(/[^0-9]/g, '');
    }

    sock = makeWASocket({
        auth: state,
        logger: pino({ level: 'silent' }),
        browser: Browsers.ubuntu('Chrome'), // Solid browser user-agent
        syncFullHistory: false
    });

    sock.ev.on('creds.update', saveCreds);

    // Agar pehle se logged in nahi hai, toh Pairing Code maangenge
    if (cleanedNumber && !sock.authState.creds.registered) {
        setTimeout(async () => {
            try {
                const code = await sock.requestPairingCode(cleanedNumber);
                console.log(`\n🔑 YOUR PAIRING CODE: \x1b[32m${code}\x1b[0m`);
                console.log('👉 Go to WhatsApp -> Linked Devices -> Link with Phone Number Instead -> Enter this code.\n');
            } catch (err) {
                console.error('Error getting pairing code:', err);
            }
        }, 6000);
    }

    sock.ev.on('connection.update', async (update) => {
        const { connection, lastDisconnect } = update;

        if (connection === 'close') {
            const statusCode = (lastDisconnect?.error)?.output?.statusCode;
            const shouldReconnect = statusCode !== DisconnectReason.loggedOut;
            
            if (shouldReconnect) {
                console.log('Reconnecting...');
                setTimeout(() => connectToWhatsApp(), 3000);
            } else {
                console.log('🔴 Logged out! Automatically cleaning up old session...');
                import('fs').then(fs => {
                    fs.rmSync('auth_info_baileys', { recursive: true, force: true });
                    console.log('✅ Cleaned up. Please restart the application (npm start).');
                    process.exit(0);
                });
            }
        } else if (connection === 'open') {
            console.log('\n==================================================');
            console.log('✅ WhatsApp OTP Service Ready & Connected!');
            console.log('==================================================\n');
        }
    });
}

// 📩 Endpoint for Spring Boot
app.post('/send-otp', async (req, res) => {
    try {
        console.log("👉 Incoming Body from Spring Boot:", req.body);
        const { phone, message } = req.body;

        if (!phone || !message) {
            return res.status(400).json({ success: false, error: 'Phone and Message are required' });
        }

        let cleanedPhone = phone.replace(/[^0-9]/g, '');
        if (!cleanedPhone.startsWith('91') && cleanedPhone.length === 10) {
            cleanedPhone = '91' + cleanedPhone;
        }

        const formattedPhone = cleanedPhone + '@s.whatsapp.net';
        await sock.sendMessage(formattedPhone, { text: message });

        console.log(`[OTP SENT] -> ${cleanedPhone}`);
        return res.json({ success: true, message: 'OTP sent successfully' });
    } catch (error) {
        console.error('Error sending OTP:', error);
        return res.status(500).json({ success: false, error: error.message });
    }
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`🚀 Node OTP Microservice running on http://localhost:${PORT}`);
    connectToWhatsApp();
});