import express from "express";
import { readFileSync, writeFileSync } from "fs";

import cors from "cors";

const app = express();
const PORT = 5500;

app.use(express.json());
app.use(cors());

app.get("/", function (req, res) {
    res.send("<h1>JSON Server</h1>");
});

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
    res.send(data["location_desc"][locationName]);
});

app.listen(process.env.PORT || PORT, "0.0.0.0", () => {
    console.log(`Listening on port ${PORT}`);
});
