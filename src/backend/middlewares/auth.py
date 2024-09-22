from fastapi import FastAPI, Request, HTTPException
from starlette.middleware.base import BaseHTTPMiddleware
from firebase_admin import auth

class LoggingMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Process the request (before forwarding to route)
        request.state.decoded_token = await self.verify_token(request)  # Pass the actual request object
        
        # Forward the request to the route or next middleware
        response = await call_next(request)
        
        # Process the response (before sending it back to the client)
        print(f"Response status code: {response.status_code}")
        
        return response  # Send the response back to the client

    # Fix this to be a class method, so it needs 'self'
    async def verify_token(self, request: Request):
        auth_header = request.headers.get("Authorization")
        
        if auth_header is None or not auth_header.startswith("Bearer "):
            raise HTTPException(status_code=401, detail="Invalid or missing authorization token")
        
        token = auth_header.split(" ")[1]
        
        try:
            # Verify the token with Firebase Admin SDK
            decoded_token = auth.verify_id_token(token)
            return decoded_token  # You can return this token info to use in the route
        except Exception as e:
            raise HTTPException(status_code=401, detail="Invalid token")
