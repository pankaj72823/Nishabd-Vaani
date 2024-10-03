# Use a base image with both Python and Node.js
FROM nikolaik/python-nodejs:latest

# Set up the working directory
WORKDIR /home/pn/app

# Switch to root to perform installations
USER root

# Install dependencies required by OpenCV
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0

# Create a virtual environment and install Python dependencies
RUN python -m venv /home/pn/app/venv
ENV PATH="/home/pn/app/venv/bin:$PATH"

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy Node.js app files and install as root
COPY package*.json ./
RUN npm install

# Switch to the 'pn' user and ensure proper ownership
# RUN chown -R pn:pn /home/pn/app

# Copy the rest of the application code
COPY . .

# Expose the necessary ports
EXPOSE 5000

# Verify Python and Node.js versions
RUN python --version
RUN node --version

# Start the application
CMD ["node", "app.js"]
