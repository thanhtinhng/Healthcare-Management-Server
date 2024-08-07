import db from '../models/index'
import CRUDService from '../services/CRUDService'

let getHomePage = async (req, res) => {
    return res.render('homepage.ejs')
    // try {
    //     let data = await db.Medicine.findAll();
    //     console.log(data)
    //     return res.render('homepage.ejs', {
    //         data: JSON.stringify(data)
    //     })
    // } catch (e) {
    //     console.log(e)
    // }
}

let getNewPatientForm = (req, res) => {
    return res.render('newpatient.ejs');
}

let postPatientCRUD = async (req, res) => {
    let message = await CRUDService.createNewUser(req.body)
    console.log(message)
    res.redirect('http://localhost:3000/login');
    return res.send("post crud")
}

let getNewDoctorForm = (req, res) => {
    return res.render('newdoctor.ejs');
}

let postDoctorCRUD = async (req, res) => {
    let message = await CRUDService.createNewDoctor(req.body)
    console.log(message)
    res.redirect('http://localhost:8080/new-doctor-form')
    return res.send("post crud")
}

module.exports = {
    getHomePage: getHomePage,
    getNewPatientForm: getNewPatientForm,
    postPatientCRUD: postPatientCRUD,
    postDoctorCRUD: postDoctorCRUD,
    getNewDoctorForm: getNewDoctorForm
}