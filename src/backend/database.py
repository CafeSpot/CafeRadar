import os
from dotenv import load_dotenv
import motor.motor_asyncio


# Load .env file
load_dotenv()

DB_URL = os.getenv("MONGODB_URL")
client = motor.motor_asyncio.AsyncIOMotorClient(DB_URL)

db = client.get_database("info")
user_collection = db.get_collection("users")