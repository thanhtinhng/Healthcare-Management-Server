import bcrypt from 'bcryptjs'
import db from '../models/index'

const salt = bcrypt.genSaltSync(10);

let createNewUser = async (data) => {
    return new Promise (async(resolve, reject) => {
        try {
            let hashPassBcrypt = await hashUserPassword(data.password);
            let patientName = data.last_name + " " + data.first_name
            await db.Patient.create({
                PatientEmail: data.email,
                AccPassword: hashPassBcrypt,
                CitizenID: data.CCCD,
                PatientName: patientName,
                Gender: data.sex,
                PatientBirthdate: data.birthdate,
                PatientPhone: data.phone,
                PatientAddr: data.addr,
                EmergencyContact: data.emergency,
            })
            resolve('Create patient succeed')
        } catch (error) {
            reject(error)
        }
    })
}

let hashUserPassword = (pass) => {
    return new Promise (async (resolve, reject) => {
        try {
            let hashPass = bcrypt.hashSync(pass, salt);
            resolve(hashPass)
        } catch (error) {
            reject(error)
        }
    })
}

let createNewDoctor = async (data) => {
    return new Promise (async(resolve, reject) => {
        try {
            let hashPassBcrypt = await hashUserPassword(data.password)
            let doctorName = data.last_name + " " + data.first_name
            await db.Doctor.create({
                DoctorName: doctorName,
                Gender: data.sex,
                DoctorBirthdate: data.birthdate,
                DateJoined: data.datejoin,
                Specialization: data.Specialization,
                Department: data.department,
                DoctorPhone: data.phone,
                DoctorEmail: data.email,
                AccPassword: hashPassBcrypt
            })
            resolve('Create patient succeed')
        } catch (error) {
            reject(error)
        }
    })
}

let getAllDoctor = async () => {
    return new Promise (async(resolve, reject) => {
        try {
            let data = await db.Doctor.findAll({
                attributes: {exclude: ['AccPassword']},
                raw: true,
            })
            resolve(data)
        } catch (error) {
            reject(error)
        }
    })
}

let getAllAppointment = async () => {
    return new Promise (async(resolve, reject) => {
        try {
            let data = await db.Appointment.findAll({
                raw: true
            })
            data = data.map(appointment => {
                let consultationTime = new Date(appointment.ConsultationTime)
                consultationTime.setHours(consultationTime.getHours() - 7) // Trừ đi 7 giờ
                const year = consultationTime.getFullYear()
                const month = String(consultationTime.getMonth() + 1).padStart(2, '0') // Tháng bắt đầu từ 0
                const day = String(consultationTime.getDate()).padStart(2, '0')
                const hours = String(consultationTime.getHours()).padStart(2, '0')
                const minutes = String(consultationTime.getMinutes()).padStart(2, '0')
                const seconds = String(consultationTime.getSeconds()).padStart(2, '0')

                // Gán lại giá trị với định dạng 'YYYY-MM-DD HH:mm:ss'
                appointment.ConsultationTime = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
                return appointment;
            });
            resolve(data)
        }
        catch (error) {
            reject(error)
        }
    })
}

let getUserInfoById = async (id) => {
    return new Promise(async (resolve, reject) => {
        try {
            let doctor = await db.Doctor.findOne({
                where: {DoctorID: id}, raw: true, attributes: {exclude: ['AccPassword']}
            })
            if (doctor) {
                resolve(doctor)
            }
            else {
                resolve([])
            }
        } catch (error) {
            reject (error)
        }
    })
}

let updateDoctorData = async (data) => {
    return new Promise (async(resolve, reject) => {
        try {
            let doctor = await db.Doctor.findOne({
                where: {DoctorID: data.id}
            })
            if (doctor) {
                doctor.DoctorName = data.name
                doctor.Gender = data.gender
                doctor.DoctorBirthdate = data.birthdate
                doctor.DateJoined = data.datejoin
                doctor.DoctorPhone = data.phone
                doctor.Department = data.department
                doctor.Specialization = data.specialization
                await doctor.save()
                
                resolve()
            }
            else {
                resolve()
            }
        } catch (error) {
            reject(error)
        }
    })
}

let deleteDoctorById = async (id) => {
    return new Promise (async(resolve, reject) => {
        try {
            let doctor = await db.Doctor.findOne({
                where: {DoctorID: id}
            })
            if(doctor) {
                await doctor.destroy()
                resolve()
            }
            else{resolve()}
        } catch (error) {
            reject(error)
        }
    })
}

module.exports = {
    createNewUser: createNewUser,
    createNewDoctor: createNewDoctor,
    getAllDoctor: getAllDoctor,
    getUserInfoById: getUserInfoById,
    updateDoctorData: updateDoctorData,
    deleteDoctorById: deleteDoctorById,
    getAllAppointment: getAllAppointment
}