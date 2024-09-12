import os
from dotenv import load_dotenv
import motor.motor_asyncio

# Load .env file
env_path = os.path.join(os.path.dirname(__file__), '../../..', '.env')
load_dotenv(dotenv_path=env_path)

DB_URL = os.getenv("MONGODB_URL")
print(f"DB_URL: {DB_URL}")
client = motor.motor_asyncio.AsyncIOMotorClient(DB_URL)


db = client.get_database("info")
user_collection = db.get_collection("users")
cafe_collection = db.get_collection("cafe")
