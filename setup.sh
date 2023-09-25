#!/bin/bash

# Prompt the user for the folder name
read -p "Enter a folder name (press Enter to use 'express-api'): " folderName

# Remove leading and trailing whitespace
folderName="$(echo -e "${folderName}" | tr -d '[:space:]')"

# Default to "express-api" if folderName is empty
if [ -z "$folderName" ]; then
  folderName="express-api"
fi

# Create the main directory
mkdir "$folderName"

# Change to the main directory
cd "$folderName" || exit


npm init -y

npm install express

mkdir "Server"

# Check if "Server" directory creation was successful
if [ $? -eq 0 ]; then
# Use an absolute path to "Server" directory
  cd "$(pwd)/Server" || exit

cat > index.js <<'EOF'
const express = require("express")

const app = express()

const port = process.env.PORT || 3000

const router = require("../Router/routes")

app.use(router)

app.listen(port, () => {
    console.log(`Server is running on port ${port}`)
})
EOF

cd ..
else
  echo "Failed to create 'Server' directory."
  exit 1
fi

mkdir Router

cd Router

cat > routes.js <<EOF
const express = require("express")
const router = express.Router()
const controller = require("../Controllers/controller")

router.get("/test", controller.helloWorld)

module.exports = router

EOF

cd ..

mkdir Controllers

cd Controllers

cat > controller.js <<EOF

const helloWorld = (req, res) => {
    res.send({
        firstName: "John",
        lastName: "Doe",
        age: 30,
        email: "john.doe@example.com",
        phone: "+1 (123) 456-7890",
        address: {
            street: "123 Main Street",
            city: "Anytown",
            state: "CA",
            postalCode: "12345",
        },
        occupation: "Software Engineer",
        gender: "Male",
        maritalStatus: "Single",
        interests: ["Reading", "Hiking", "Photography"],
    })
}

module.exports = { helloWorld }
EOF

cd ..

# Create a Dockerfile in the main directory
cat > Dockerfile <<EOF
# Use the official Node.js runtime as a parent image
FROM node:14

# Set the working directory to /app
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all project files to the working directory
COPY . .

# Expose port 3000
EXPOSE 3000

# Define the command to run your application
CMD [ "node", "Server/index.js" ]
EOF

#Back to root
cd ..

npm init vite@latest



# Get the name of the most recently created folder in the root folder
recentFolderName=$(ls -td */ | head -n 1 | sed 's:/$::')

cd $recentFolderName

npm install

# Create a Dockerfile in the main directory
cat > Dockerfile <<EOF
# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory to /app
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all project files to the working directory
COPY . .

# Expose port 5173 for Vite development server
EXPOSE 5173

# Run the Vite development server
CMD ["npm", "run", "dev"]
EOF

cd ..


# Create a docker-compose file in the main directory
cat > docker-compose.yml <<EOF
version: '3'
services:
  frontend:
    build:
      context: ./$recentFolderName # Path to the directory containing your frontend Dockerfile
    ports:
      - "5173:5173"      # Map the frontend container's port 3000 to the host
    depends_on:
      - backend           # Ensure the backend service is started before the frontend

  backend:
    build:
      context: ./$folderName # Path to the directory containing your backend Dockerfile
    ports:
      - "3001:3001"      # Map the backend container's port 3000 to the host

networks:
  default:
    driver: bridge
EOF

echo "Most recently created folder in the root folder: $recentFolderName"
echo "Project setup in the '$folderName' directory."

# End of your script