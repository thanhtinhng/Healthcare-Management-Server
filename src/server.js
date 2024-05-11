import express from "express"
import bodyParser from "body-parser"
import viewEngine from "./config/viewEngine"
import connectDB from "./config/connectDB"
import initWebRoutes from "./route/web"
require("dotenv").config();

let app = express();

//config app
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}))

viewEngine(app);
initWebRoutes(app);
connectDB();

//if PORT undefined => use port 8000
let port = process.env.PORT || 8000;

app.listen(port, () => {
    console.log("Backend is running on port: " + port);
});
