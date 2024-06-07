import db from "../models/index"

let getDoctorByDepartment = (departmentId) => {
    return new Promise(async (resolve, reject) => {
        try {
            let doctorData = {}
            let doctors = await db.Doctor.findAll({
                where: {
                    Department: departmentId
                },
                attributes: { exclude: ['AccPassword'] }
            })
            if (doctors && doctors.length > 0) {
                doctorData.errCode = 0
                doctorData.errMessage = 'OK'
                doctorData.doctors = doctors
            }
            else{
                doctorData.errCode = '-1'
                doctorData.errMessage = 'Wrong department!'
            }
            resolve(doctorData)
        } catch (error) {
            reject(error)
        }
    })
}

let getDoctorById = (doctorId) => {
    return new Promise(async (resolve, reject) => {
        try {
            let doctorData = {}
            let doctor = await db.Doctor.findOne({
                where: {
                    DoctorID: doctorId
                },
                attributes: { exclude: ['AccPassword'] }
            })
            if (doctor) {
                doctorData.errCode = 0
                doctorData.errMessage = 'OK'
                doctorData.doctor = doctor
            }
            else{
                doctorData.errCode = '-1'
                doctorData.errMessage = 'Doctor is not exist!'
            }
            resolve(doctorData)
        } catch (error) {
            reject(error)
        }
    })
}

module.exports = {
    getDoctorByDepartment: getDoctorByDepartment,
    getDoctorById: getDoctorById
}