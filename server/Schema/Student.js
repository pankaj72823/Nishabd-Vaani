import mongoose from 'mongoose';
import bcrypt from 'bcryptjs';
import AttemptedQuiz from './AttemptedQuiz.js';

const dailyActivitySchema = new mongoose.Schema({
    date: { type: Date, required: true },
    activeLevel: { type: Number, default: 0 }
});

const studentSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    email: { 
        type: String,
        required: true,
        unique: true 
    },
    password: { 
        type: String, 
        required: true 
    },
    username : {
        type: String, 
        required: true,
        unique: true 
    },
    gurdianEmail: { 
        type: String, 
        required: true,
        unique: true 
    },
    dailyActivity: [dailyActivitySchema],
    attemptedQuiz: {
        science: { type: [AttemptedQuiz.schema], default: [] }, // Array of QuizAttempt objects
        maths: { type: [AttemptedQuiz.schema], default: [] },
        alpha: { type: [AttemptedQuiz.schema], default: [] },
        word: { type: [AttemptedQuiz.schema], default: [] },
  },
}, { timestamps: true });

studentSchema.pre('save', async function (next) {
    if (!this.isModified('password')) return next();

    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
});

// Method to compare input password with hashed password
studentSchema.methods.comparePassword = async function (password) {
    return await bcrypt.compare(password, this.password);
};

// Export Student model
const Student = mongoose.model('Student', studentSchema);
export default Student;