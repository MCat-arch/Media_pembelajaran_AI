const axios = require("axios");
const { OPENROUTER_API_KEY, OPENROUTER_URL } = require("../config/config");

// ...existing code...
const getAIResponse = async (message) => {
  try {
    const response = await axios.post(
      OPENROUTER_URL,
      {
        model: "deepseek/deepseek-chat-v3.1:free",
        messages: [
          {
            role: "user",
            content: `Jelaskan ini "${message}" sesuai dengan konteks sejarah. 
            Jika pertanyaan tidak berhubungan dengan sejarah, tolong tolak untuk merespon 
            dengan menjawab: "Pertanyaan tidak terkait dengan sejarah."`,
          },
        ],
      },
      {
        headers: {
          Authorization: `Bearer ${OPENROUTER_API_KEY}`,
          "Content-Type": "application/json",
        },
      }
    );

    // Tambahkan log respons
    console.log("OpenRouter API response:", response.data);

    // Cek apakah choices ada dan tidak kosong
    if (
      response.data &&
      Array.isArray(response.data.choices) &&
      response.data.choices.length > 0 &&
      response.data.choices[0].message &&
      response.data.choices[0].message.content
    ) {
      return response.data.choices[0].message.content;
    } else {
      throw new Error("Respons OpenRouter API tidak sesuai format.");
    }
  } catch (error) {
    console.error("OpenRouter Service Error:", error.response?.data || error.message);
    throw new Error("Gagal menghubungi OpenRouter API");
  }
};
// ...existing code...

module.exports = { getAIResponse };
