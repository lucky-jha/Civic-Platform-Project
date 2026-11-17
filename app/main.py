from fastapi import FastAPI, Depends, UploadFile, File, Form, HTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
from typing import Optional
import shutil
import os

from database import engine, SessionLocal, Base
from models import Complaint as ComplaintModel

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Civic Platform API")

# Create an "uploads" folder for images if it doesn't exist
os.makedirs("static/uploads", exist_ok=True)
app.mount("/static", StaticFiles(directory="static"), name="static")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/")
def read_index():
    return FileResponse("static/index.html")

@app.get("/admin")
def read_admin():
    return FileResponse("static/admin.html")

# 1. Submit a complaint (Now accepts an image!)
@app.post("/complaints")
def create_complaint(
    title: str = Form(...), 
    description: str = Form(...), 
    image: Optional[UploadFile] = File(None), 
    db: Session = Depends(get_db)
):
    image_path = None
    
    # If they uploaded an image, save it to the uploads folder
    if image:
        image_path = f"static/uploads/{image.filename}"
        with open(image_path, "wb") as buffer:
            shutil.copyfileobj(image.file, buffer)
        image_path = f"/static/uploads/{image.filename}" # URL for the frontend

    new_complaint = ComplaintModel(
        title=title, 
        description=description, 
        image_url=image_path,
        status="OPEN"
    )
    db.add(new_complaint)
    db.commit()
    db.refresh(new_complaint)
    
    return {"message": "Complaint received", "data": new_complaint}

@app.get("/complaints")
def get_complaints(db: Session = Depends(get_db)):
    return db.query(ComplaintModel).all()

# 2. Admin Endpoint to resolve the complaint
@app.patch("/complaints/{complaint_id}/resolve")
def resolve_complaint(complaint_id: int, db: Session = Depends(get_db)):
    # (In a full app, we would check a JWT token here to verify they are an Admin)
    complaint = db.query(ComplaintModel).filter(ComplaintModel.id == complaint_id).first()
    if not complaint:
        raise HTTPException(status_code=404, detail="Complaint not found")
    
    complaint.status = "RESOLVED"
    db.commit()
    db.refresh(complaint)
    
    return {"message": "Complaint resolved", "data": complaint}