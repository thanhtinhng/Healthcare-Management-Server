import doctorService from "../services/doctorService"

let getDoctorByDepartment = async (req, res) => {
    const departmentId = req.query.departmentId;
    try {
        let doctors = await doctorService.getDoctorByDepartment(departmentId);
        res.json(doctors);
    } catch (error) {
        console.log(error)
        return res.status(200).json({
            errCode: -1,
            message: 'Error from server...'
        })
    }
} 

let getDoctorById = async (req, res) => {
    const doctorId = req.query.doctorId;
    try {
        let doctor = await doctorService.getDoctorById(doctorId);
        res.json(doctor);
    } catch (error) {
        console.log(error)
        return res.status(200).json({
            errCode: -1,
            message: 'Error from server...'
        })
    }
}

let handleAppoint = async (req, res) => {
    let date = req.body.date
    let time = req.body.time
    let userId = req.body.userId
    let doctorId = req.body.doctorId
    let symptom = req.body.symptom

    if (!date || !time) {
        return res.status(500).json({
            errCode: 1,
            message: "Vui lòng chọn ngày hoặc giờ!"
        })
    }

    let appointmentData = await doctorService.handleUserAppoint(date, time, userId, doctorId, symptom)

    return res.status(200).json({
        errCode: appointmentData.errCode,
        message: appointmentData.errMessage
    })
}
    


module.exports = {
    getDoctorByDepartment: getDoctorByDepartment,
    getDoctorById: getDoctorById,
    handleAppoint: handleAppoint
}