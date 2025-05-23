import express from "express"
import homeController from "../controllers/homeController"
import userController from "../controllers/userController"
import doctorController from "../controllers/doctorController"

let router = express.Router();

let initWebRoutes = (app) => {
    router.get("/", homeController.getHomePage)
    router.get("/new-patient-form", homeController.getNewPatientForm);
    router.get("/new-doctor-form", homeController.getNewDoctorForm);
    router.post("/new-patient", homeController.postPatientCRUD);
    router.post("/new-doctor", homeController.postDoctorCRUD)
    router.get("/get-doctor", homeController.getDoctorCRUD);
    router.post("/api/login", userController.handleLogin);
    router.get("/api/doctor-by-department", doctorController.getDoctorByDepartment)
    router.get("/api/doctor-by-id", doctorController.getDoctorById)
    router.post("/api/appointment", doctorController.handleAppoint)
    router.get("/edit-crud", homeController.getEditCRUD)
    router.post("/put-crud", homeController.putCRUD)
    router.get("/delete-crud", homeController.deleteCRUD)
    router.get("/get-appointment", homeController.getAppointment)

    return app.use("/", router)
}

module.exports = initWebRoutes;