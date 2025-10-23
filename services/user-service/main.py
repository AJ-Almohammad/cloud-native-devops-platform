from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from typing import List, Optional
import uuid
from datetime import datetime

app = FastAPI(
    title="User Service API",
    description="User management microservice for Multi-Everything DevOps",
    version="1.0.0"
)

# In-memory storage (replace with database later)
users_db = []

class User(BaseModel):
    id: str
    email: str
    username: str
    full_name: str
    created_at: datetime
    is_active: bool

class UserCreate(BaseModel):
    email: str
    username: str
    full_name: str

class UserUpdate(BaseModel):
    email: Optional[str] = None
    username: Optional[str] = None
    full_name: Optional[str] = None
    is_active: Optional[bool] = None

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "user-service",
        "timestamp": datetime.utcnow().isoformat()
    }

@app.get("/users", response_model=List[User])
async def get_users():
    return users_db

@app.get("/users/{user_id}", response_model=User)
async def get_user(user_id: str):
    user = next((u for u in users_db if u["id"] == user_id), None)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@app.post("/users", response_model=User)
async def create_user(user_data: UserCreate):
    user = User(
        id=str(uuid.uuid4()),
        email=user_data.email,
        username=user_data.username,
        full_name=user_data.full_name,
        created_at=datetime.utcnow(),
        is_active=True
    )
    users_db.append(user.dict())
    return user

@app.put("/users/{user_id}", response_model=User)
async def update_user(user_id: str, user_data: UserUpdate):
    user_index = next((i for i, u in enumerate(users_db) if u["id"] == user_id), None)
    if user_index is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    user = users_db[user_index]
    update_data = user_data.dict(exclude_unset=True)
    user.update(update_data)
    users_db[user_index] = user
    
    return user

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)