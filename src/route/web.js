import express from "express"
import homeController from "../controllers/homeController"

let router = express.Router();

let initWebRoutes = (app) => {
    router.get("/", homeController.getHomePage)

    router.get("/sonynguyen", (reg, res) => {
        return res.send('Hello World from sony');
    });
    return app.use("/", router);
}

module.exports = initWebRoutes;