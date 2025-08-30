const express = require("express");
const { chatWithAI } = require("../controller/ai_controller");

const router = express.Router();

// POST /chat
router.post("/chat", chatWithAI);

module.exports = router;
