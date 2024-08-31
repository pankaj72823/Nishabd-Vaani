import cors from 'cors';

const corsConfig = {
  origin: 'http://localhost:5173'
};

export default cors(corsConfig);
