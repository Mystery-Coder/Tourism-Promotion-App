import express from "express";
import { readFileSync, writeFileSync } from "fs";
import { URL, fileURLToPath } from "url";
import { getRandomElements, shuffleArray } from "./func.js";
import { getDistance } from "geolib";
import { configDotenv } from "dotenv";
import { GoogleGenerativeAI } from "@google/generative-ai";
import path from "path";
import cors from "cors";

configDotenv();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

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

app.get("/geo_data_locations/:userLat/:userLng", async function (req, res) {
    //userLat, userLng sent from frontend
    let userLat = +req.params.userLat;
    let userLng = +req.params.userLng;

    let data = await readFileSync(JSON_FILENAME); //copy of file
    data = JSON.parse(data);
    let location_geo_data = data["location_geo_data"];

    let keys = Object.keys(location_geo_data);

    for (let i = 0; i < keys.length; i++) {
        let key = keys[i];
        let lat = location_geo_data[key]["lat"];
        let lng = location_geo_data[key]["lng"];

        let dist =
            getDistance(
                { latitude: userLat, longitude: userLng },
                { latitude: lat, longitude: lng }
            ) / 1000; //in km

        location_geo_data[key]["userDist"] = dist;
    }

    res.send(location_geo_data); //Send only the lat-lng with dist also of all locations
});

app.get("/location_details/:locationName", async function (req, res) {
    let data = await readFileSync(JSON_FILENAME);
    data = JSON.parse(data);
    let locationName = req.params.locationName;

    let details = data["location_desc"][locationName]; //Need to add imageURL to this details obj before sending
    details["imageURL"] = `http://localhost:${PORT}/images/${locationName}.png`; //This causes issues on mobile due to the localhost address

    res.status(200);
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

app.post("/querygemini", async (req, res) => {
    const reqData = req.body;

    const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

    const prompt =
        "Limit to 20 lines, this is a prompt from a user of a tourism promotion app:" +
        reqData.prompt;

    const result = await model.generateContent(prompt);
    const output = result.response.text();

    res.send({ output });
});

app.post("/add_location", async (req, res) => {
    const reqData = req.body;

    const parsedURL = new URL(reqData.url);
    const coordinates = parsedURL.searchParams.get("q");

    // Split the coordinates into latitude and longitude
    const [latitude, longitude] = coordinates.split(",");

    let data = await readFileSync(JSON_FILENAME); //copy of file
    data = JSON.parse(data);

    let n = reqData.name.replace(" ", "_");
    data["location_geo_data"][n] = { lat: +latitude, lng: +longitude };
    data["location_desc"][n] = { desc: reqData.desc, maps_link: reqData.url };

    await writeFileSync(JSON_FILENAME, JSON.stringify(data));

    res.status(200);
    res.send();
});

app.listen(process.env.PORT || PORT, "0.0.0.0", () => {
    console.log(`Server running at http://localhost:${PORT}/`);
});
