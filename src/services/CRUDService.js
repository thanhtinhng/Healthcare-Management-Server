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
            resolve(hashPass);
        } catch (error) {
            reject(error);
        }
    })
}

module.exports = {
    createNewUser: createNewUser
}