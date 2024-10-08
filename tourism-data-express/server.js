import express from "express";
import { readFileSync, writeFileSync } from "fs";

import cors from "cors";

const app = express();
const PORT = 5500;

app.use(express.json());
app.use(cors());

app.get("/", async function (req, res) {

	let data = await readFileSync('locations_data.json');
	data = JSON.parse(data);
	res.send(data);
});


app.get("/get_locations", async function (req, res) {

	let data = await readFileSync();
	data = JSON.parse(data);
	res.send(data);
});


app.listen(process.env.PORT || PORT, () => {
	console.log(`Listening on port ${PORT}`);
});
