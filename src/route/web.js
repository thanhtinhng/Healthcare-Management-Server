import express from "express"
import homeController from "../controllers/homeController"
import userController from "../controllers/userController"
import doctorController from "../controllers/doctorController"

let router = express.Router();

let initWebRoutes = (app) => {
    router.get("/", homeController.getHomePage)
    router.get("/crud", homeController.getCRUD);
    router.post("/post-crud", homeController.postCRUD);

    router.post("/api/login", userController.handleLogin);

    router.get("/api/doctor-by-department", doctorController.getDoctorByDepartment)


    return app.use("/", router)
}

module.exports = initWebRoutes;