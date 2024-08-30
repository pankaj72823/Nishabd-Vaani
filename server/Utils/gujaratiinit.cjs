const mongoose = require('mongoose');
const cloudinary = require('cloudinary').v2;
const fs = require('fs');
const path = require('path');

const alphabetSchema = new mongoose.Schema({
  alphabet: {
    type: String,
    required: true,
    unique: true,
  },
  signImage: {
    type: String, 
    required: true,
  },
  objectImage: {
    type: String,  
    required: true,
  },
});

const GujAlphabet = mongoose.model('GujAlphabet', alphabetSchema);


cloudinary.config({
    cloud_name: 'dihixxcnt',
    api_key: '434654673153384',
    api_secret: 'cgZ-S65XRgJzwn_KahrHZOELeW0',
  });
  
// Connect to MongoDB
// const mongoUri = 'mongodb+srv://amangaloliya2212:7FJeYR1bdZnqeg0m@sih.9mj3j.mongodb.net/SIH?retryWrites=true&w=majority&appName=SIH';
mongoUri="mongodb://localhost:27017/signGif"

mongoose.connect(mongoUri, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('Error connecting to MongoDB:', err));

// Function to upload images to Cloudinary and save to MongoDB
async function uploadAndSaveImages(folderPath) {
  const files = fs.readdirSync(folderPath);

  const imageGroups = files.reduce((groups, file) => {
    // this is for Remove extension and normalize the name (e.g., A, A (2)) and i want to normalize ( A, A2)
    const name = path.basename(file, path.extname(file)).replace(/2$/, '').toUpperCase();
    if (!groups[name]) groups[name] = [];
    groups[name].push(file);
    return groups;
  }, {});

  for (const [alphabet, images] of Object.entries(imageGroups)) {
    if (images.length === 2) {
      try {
        let signImagePath, objectImagePath;

        // Determine which image is the signImage and which is the objectImage
        if (images[0].includes('(2)')) {
          objectImagePath = path.join(folderPath, images[0]);
          signImagePath = path.join(folderPath, images[1]);
        } else {
          signImagePath = path.join(folderPath, images[0]);
          objectImagePath = path.join(folderPath, images[1]);
        }

        // Upload both images to Cloudinary under the "learning" folder
        const signImageUpload = await cloudinary.uploader.upload(signImagePath, {
          folder: 'GujaratiAlphabet',
        });
        const objectImageUpload = await cloudinary.uploader.upload(objectImagePath, {
          folder: 'GujaratiAlphabet',
        });
        signImageUpload
        // Save the data in MongoDB
        const newAlphabet = new GujAlphabet({
          alphabet,
          signImage: objectImageUpload.secure_url,
          objectImage: signImageUpload.secure_url,
        });

        await newAlphabet.save();
        console.log(`Saved ${alphabet} to database`);
      } catch (error) {
        console.error(`Error processing ${alphabet}:`, error);
      }
    } else {
      console.log(`Skipping ${alphabet}: Expected 2 images, found ${images.length}`);
    }
  }
  mongoose.disconnect();
}

// Run the script
uploadAndSaveImages('../SIH Assets/gujaratiAlphabet');
