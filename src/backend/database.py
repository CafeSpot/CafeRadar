import os
from dotenv import load_dotenv

# Load .env file
load_dotenv()

DB_URL = os.getenv("MONGODB_URL")
