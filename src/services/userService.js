import db from "../models/index"
import bcrypt from 'bcryptjs'

let handleUserLogin = (email, password) => {
    return new Promise(async(resolve, reject) => {
        try {
            let userData = {}
            let isExists = await checkUserEmail(email)
            if (isExists) {
                let user = await db.Patient.findOne({
                    where: {PatientEmail: email},
                    raw: true
                })
                if (user){
                    let check = await bcrypt.compareSync(password, user.AccPassword)
                    if (check){
                        userData.errCode = 0
                        userData.errMessage = 'OK'
                        delete user.AccPassword
                        userData.user = user
                    }
                    else{
                        userData.errCode = 3
                        userData.errMessage = 'Tài khoảng hoặc mật khẩu sai!'
                    }
                }
                else{
                    userData.errCode = 2
                    userData.errMessage = "Tài khoảng hoặc mật khẩu sai!"
                }
            }
            else
            {
                userData.errCode = 1
                userData.errMessage = "Tài khoảng hoặc mật khẩu sai!"
            }
            resolve(userData)
        } catch (error) {
            reject(error)
        }
    })
}

let checkUserEmail = (userEmail) => {
    return new Promise(async(resolve, reject) => {
        try {
            let user = await db.Patient.findOne({
                where: {PatientEmail: userEmail}
            })
            if (user) resolve(true)
            else resolve(false)
        } catch (error) {
            reject(error)
        }
    })
}

module.exports = {
    handleUserLogin: handleUserLogin,
    checkUserEmail: checkUserEmail,
}