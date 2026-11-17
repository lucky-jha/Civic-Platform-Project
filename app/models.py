from sqlalchemy import Column, Integer, String, Text
from database import Base

class Complaint(Base):
    __tablename__ = "complaints"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    description = Column(Text)
    status = Column(String, default="OPEN")
    image_url = Column(String, nullable=True)