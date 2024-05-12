import db from '../models/index'

let getHomePage = async (req, res) => {
    //return res.render('homepage.ejs')
    try {
        let data = await db.InsuranceDetail.findAll();
        console.log(data)
        return res.render('homepage.ejs', {
            data: JSON.stringify(data)
        })
    } catch (e) {
        console.log(e)
    }
}

module.exports = {
    getHomePage: getHomePage,
}