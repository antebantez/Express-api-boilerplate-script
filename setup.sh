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
echo "Project setup in the '$folderName' directory."

# End of your script