const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const chatRoutes = require("./routes/ai_route");
const { PORT } = require("./config/config");

const app = express();

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Routes
app.use("/api", chatRoutes);

// Root check
app.get("/", (req, res) => {
  res.send("Chatbot backend is running 🚀");
});

// Run server
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
