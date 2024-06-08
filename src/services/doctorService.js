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

let handleUserAppoint = async (date, time, userId, doctorId) => {
    return new Promise(async(resolve, reject) => {
        try {
            let appointmentData = {}
            let dateTime = date + ' ' + time
            let isExists = await checkAvailableAppointment(dateTime, doctorId)
            if (isExists === false) {
                await db.Appointment.create({
                    DoctorID: doctorId,
                    PatientID: userId,
                    ConsultationTime: dateTime
                })
                appointmentData.errCode = 0
                appointmentData.errMessage = 'OK'
            }
            else if (isExists) {
                appointmentData.errCode = 2
                appointmentData.errMessage = 'Lịch không còn trống!'
            }
            resolve(appointmentData)
        } catch (error) {
            reject(error)
        }
    })
}

let checkAvailableAppointment = async (dateTime, doctorId) => {
    return new Promise(async(resolve, reject) => {
        try {
            
            let appointment = await db.Appointment.findOne({
                where: {
                    DoctorID: doctorId,
                    ConsultationTime: dateTime
                }
            })
            if (appointment) resolve(true)
            else resolve(false)
        } catch (error) {
            reject(error)
        }
    })
}

module.exports = {
    getDoctorByDepartment: getDoctorByDepartment,
    getDoctorById: getDoctorById,
    handleUserAppoint: handleUserAppoint
}