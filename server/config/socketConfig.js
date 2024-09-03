import { Server } from 'socket.io';

let io;
let websocketActive = false;

export const getIOInstance = (server) => {
  if (!websocketActive) {
    io = new Server(server, {
      cors: {
        origin: "*",
        methods: ["GET", "POST"]
      }
    });
    websocketActive = true;
  }
  return io;
};

export const isWebSocketActive = () => websocketActive;
export const setWebSocketInactive = () => { websocketActive = false; };
