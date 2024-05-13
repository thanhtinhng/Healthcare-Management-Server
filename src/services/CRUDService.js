import bcrypt from 'bcryptjs'
import db from '../models/index'

const salt = bcrypt.genSaltSync(10);
//TEST
let createNewUser = async (data) => {
    return new Promise (async(resolve, reject) => {
        try {
            let hashPassBcrypt = await hashUserPassword(data.password);
            await db.Patient.create({
                PatientEmail: data.email,
                AccPassword: hashPassBcrypt,
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