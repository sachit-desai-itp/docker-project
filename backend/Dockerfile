# Use official Python slim image
FROM python:3.11-slim

# Set working directory inside container
WORKDIR /app

# Install system dependencies required for psycopg2 and build tools
RUN apt-get update && apt-get install -y gcc libpq-dev && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY backend/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend app source code
COPY backend/ .

# Expose port 5000 (Flask default)
EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]