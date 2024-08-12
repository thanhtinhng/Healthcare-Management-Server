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
    return res.send('post crud')
}

let getDoctorCRUD = async (req, res) => {
    let data = await CRUDService.getAllDoctor()
    console.log(data)
    return res.render('getAllDoctor.ejs', {
        dataTable: data
    })
}

let getEditCRUD = async (req, res) => {
    let doctorId = req.query.id
    if (doctorId) {
        let doctorData = await CRUDService.getUserInfoById(doctorId)
        console.log(doctorData)
        return res.render("editCRUD.ejs", {
            doctorData: doctorData
        })
    }
    else {
        return res.send("doctor not found")
    }
}

let putCRUD = async (req, res) => {
    let data = req.body
    let allDoctor = await CRUDService.updateDoctorData(data)
    return res.render("getAllDoctor.ejs", {
        dataTable: allDoctor
    }
    )
}

module.exports = {
    getHomePage: getHomePage,
    getNewPatientForm: getNewPatientForm,
    postPatientCRUD: postPatientCRUD,
    postDoctorCRUD: postDoctorCRUD,
    getNewDoctorForm: getNewDoctorForm,
    getDoctorCRUD: getDoctorCRUD,
    getEditCRUD: getEditCRUD,
    putCRUD: putCRUD
}