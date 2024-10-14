import express from "express";
import { readFileSync, writeFileSync } from "fs";
import { fileURLToPath } from "url";
import { getRandomElements, shuffleArray } from "./func.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

import path from "path";

import cors from "cors";

const app = express();
const PORT = 5500;
const JSON_FILENAME = "locations_data.json";

app.use(express.json());
app.use(cors());

app.get("/", function (req, res) {
    res.send("<h1>JSON Server</h1>");
});

// Middleware to serve static files from the images directory
app.use("/images", express.static(path.join(__dirname, "images")));

app.get("/geo_data_locations", async function (req, res) {
    console.log("got req");
    let data = await readFileSync(JSON_FILENAME);
    data = JSON.parse(data);

    res.send(data["location_geo_data"]); //Send only the lat-lng of all locations
});

app.get("/location_details/:locationName", async function (req, res) {
    let data = await readFileSync("JSON_FILENAME");
    data = JSON.parse(data);
    let locationName = req.params.locationName;
    console.log(locationName);
    let details = data["location_desc"][locationName]; //Need to add imageURL to this details obj before sending
    details["imageURL"] = `http://localhost:${PORT}/images/${locationName}.png`;

    res.send(details);
});

app.get("/quiz", async function (req, res) {
    let noOfQuestions = 3;
    let noOfOptions = 3;

    let data = await readFileSync(JSON_FILENAME);
    data = JSON.parse(data);

    let locationNames = Object.keys(data["location_geo_data"]);

    let questions = []; //List of Objects which will have options,ans,imageURL - Only identification quiz

    for (let i = 0; i < noOfQuestions; i++) {
        let copy_locationNames = [...locationNames]; //To avoid repeats use this array to select from copy then remove the selected,
        //Then use this copy to select random choices

        const randomIndex = Math.floor(
            Math.random() * copy_locationNames.length
        );
        let locationName = locationNames[randomIndex];
        copy_locationNames.splice(randomIndex, 1); //remove the ans

        let ans = locationName;
        let imageURL = `http://localhost:${PORT}/images/${locationName}.png`;

        let options = shuffleArray(
            [locationName].concat(
                getRandomElements(copy_locationNames, noOfOptions - 1)
            )
        );

        questions.push({
            options,
            imageURL,
            ans,
        });
    }

    res.send(questions);
});

app.listen(process.env.PORT || PORT, "0.0.0.0", () => {
    console.log(`http://localhost:${PORT}/`);
});
