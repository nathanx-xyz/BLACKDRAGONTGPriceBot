import requests
from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import ApplicationBuilder, CommandHandler, CallbackQueryHandler, ContextTypes

# CoinMarketCap API key (replace with your own)
API_KEY = "YOUR_API_KEY"
CMC_URL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest"

# Function to fetch the price of BlackDragon (BDT)
def get_blackdragon_price():
    headers = {
        "Accepts": "application/json",
        "X-CMC_PRO_API_KEY": API_KEY,
    }
    params = {"symbol": "BDT", "convert": "USD"}
    try:
        response = requests.get(CMC_URL, headers=headers, params=params)
        response.raise_for_status()
        data = response.json()
        price = data["data"]["BDT"]["quote"]["USD"]["price"]
        return f"The current price of BlackDragon (BDT) is ${price:.2f} USD."
    except requests.exceptions.RequestException as e:
        return f"Error fetching price: {e}"
    except KeyError:
        return "The BlackDragon (BDT) token data is currently unavailable."

# Start command handler
async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    keyboard = [
        [InlineKeyboardButton("Check BlackDragon Price", callback_data="check_price")]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.message.reply_text(
        "Welcome! Click the button below to get the current price of BlackDragon (BDT).",
        reply_markup=reply_markup,
    )

# Callback handler for button clicks
async def button_handler(update: Update, context: ContextTypes.DEFAULT_TYPE):
    query = update.callback_query
    await query.answer()  # Acknowledge the callback query
    
    if query.data == "check_price":
        price_message = get_blackdragon_price()
        await query.edit_message_text(text=price_message)

# Main function to start the bot
if __name__ == "__main__":
    # Replace 'YOUR_TELEGRAM_BOT_TOKEN' with your actual bot token from BotFather
    TELEGRAM_BOT_TOKEN = "YOUR_TELEGRAM_BOT_TOKEN"
    
    app = ApplicationBuilder().token(TELEGRAM_BOT_TOKEN).build()
    
    # Add handlers
    app.add_handler(CommandHandler("start", start))
    app.add_handler(CallbackQueryHandler(button_handler))

    # Run the bot
    print("Bot is running...")
    app.run_polling()
