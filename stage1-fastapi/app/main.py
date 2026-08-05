from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "DevSecOps Pipeline Stage 1 OK!"}

@app.get("/health")
def health_check():
    return {"status": "healthy", "code": 200}
