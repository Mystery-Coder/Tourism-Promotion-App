import express from "express";

import cors from "cors";

const app = express();
const PORT = 5500;

app.use(express.json());
app.use(cors());

app.get("/", function (req, res) {
	
	let data = {
        data: [1,334]
    }
	res.send(data);
});


app.listen(process.env.PORT || PORT, () => {
	console.log(`Listening on port ${PORT}`);
});
