const cloudinary = require('cloudinary').v2;
const mongoose = require('mongoose');
const fs = require('fs');
const path = require('path');

// Configure Cloudinary
cloudinary.config({
    cloud_name: 'dihixxcnt',
    api_key: '434654673153384',
    api_secret: 'cgZ-S65XRgJzwn_KahrHZOELeW0',
  });
  
// Define Mongoose schema and model
const signImageSchema = new mongoose.Schema({
  number: { type: Number, required: true },
  signImage: { type: String, required: true } // URL for the image
});

const NumberImage = mongoose.model('NumberImage', signImageSchema);

// Connect to MongoDB
const mongoUri = 'mongodb://localhost:27017/signGif';
mongoose.connect(mongoUri, {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB connection error:', err));

// Function to upload image and save URL to MongoDB
async function uploadImageAndSave(filePath, number) {
  try {
    const result = await cloudinary.uploader.upload(filePath, {
      folder: 'numbers' // Specify the folder in Cloudinary
    });
    const newSignImage = new NumberImage({
      number,
      signImage: result.secure_url
    });
    await newSignImage.save();
    console.log(`Saved ${filePath} as ${result.secure_url}`);
  } catch (err) {
    console.error(`Failed to upload ${filePath}:`, err);
  }
}

// Main function to process all images in a folder
async function processImages(folderPath) {
  const files = fs.readdirSync(folderPath);

  for (const file of files) {
    const filePath = path.join(folderPath, file);
    const number = parseInt(file.split('.')[0], 10); // Example: extract number from filename
    await uploadImageAndSave(filePath, number);
  }

  mongoose.connection.close(); // Close the connection after processing
}

// Run the script
processImages('../SIH Assets/Numbers'); // Replace with your folder path
