# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

COPY requirements.txt /app

# Install dependencies
RUN pip install -r requirements.txt

# Copy the current directory contents into the container
COPY . /app



# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
