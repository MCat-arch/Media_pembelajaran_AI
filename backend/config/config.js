require("dotenv").config();

module.exports ={
  OPENROUTER_API_KEY: process.env.OPENROUTER_API_KEY,
  OPENROUTER_URL: process.env.OPENROUTER_URL || "https://openrouter.ai/api/v1/chat/completions",
  PORT: process.env.PORT || 5000,
}