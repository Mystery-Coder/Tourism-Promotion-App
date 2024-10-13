import express from "express";
import { readFileSync, writeFileSync } from "fs";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

import path from "path";

import cors from "cors";

const app = express();
const PORT = 5500;

app.use(express.json());
app.use(cors());

app.get("/", function (req, res) {
    res.send("<h1>JSON Server</h1>");
});

// Middleware to serve static files from the images directory
app.use("/images", express.static(path.join(__dirname, "images")));

app.get("/geo_data_locations", async function (req, res) {
    console.log("got req");
    let data = await readFileSync("locations_data.json");
    data = JSON.parse(data);

    res.send(data["location_geo_data"]); //Send only the lat-lng of all locations
});

app.get("/location_details/:locationName", async function (req, res) {
    let data = await readFileSync("locations_data.json");
    data = JSON.parse(data);
    let locationName = req.params.locationName;
    console.log(locationName);
    let details = data["location_desc"][locationName]; //Need to add imageURL to this details obj before sending
    details["imageURL"] = `http://localhost:${PORT}/images/${locationName}.png`;

    res.send(details);
});

app.listen(process.env.PORT || PORT, "0.0.0.0", () => {
    console.log(`http://localhost:${PORT}/`);
});
