import db from "../models/index"

let getDoctorByDepartment = (departmentId) => {
    return new Promise(async (resolve, reject) => {
        try {
            let doctorData = {}
            let doctors = await db.Doctor.findAll({
                where: {
                    Department: departmentId
                }
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

module.exports = {
    getDoctorByDepartment: getDoctorByDepartment,
}