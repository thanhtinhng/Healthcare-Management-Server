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

module.exports = {
    getDoctorByDepartment: getDoctorByDepartment,
    getDoctorById: getDoctorById
}