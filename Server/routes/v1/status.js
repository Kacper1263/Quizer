const express = require('express')
const fs = require('fs')
const folderSize = require('get-folder-size')
const router = express.Router()

//#region Config variables
var localtunnelEnabled = false;
var tunnelUrlList = []
var adminPassword = randomFromZeroToNine() + randomFromZeroToNine() + randomFromZeroToNine() + randomFromZeroToNine() //Generate 4 random numbers
var databaseName = "questions"
var apiPort = 5000;

// Get data from config
var cfg = fs.readFileSync("./config.json")
cfg = JSON.parse(cfg)
localtunnelEnabled = cfg.localtunnelEnabled
tunnelUrlList = cfg.tunnelUrlList
adminPassword = cfg.adminPassword
databaseName = cfg.databaseName
apiPort = cfg.apiPort
//#endregion
//#region db settings
const low = require('lowdb')
const FileSync = require('lowdb/adapters/FileSync') 
const adapter = new FileSync(`${databaseName}.json`)
const db = low(adapter)
//#endregion

// *****************************
// *   API starts from there   *
// *****************************

db.defaults({ questions: [] }).write() //default variables for database

router.get("/", (req, res) => {
    db.read()
    folderSize("./img", (err, size) => {
        if(err){
            console.log(err)
            return res.send({
                success: "false",
                message: "Cant get images folder size"
            })
        }

        res.status(200).send({
            success: "true",
            message: "Server status",
            amountOfQuestions: db.get("questions").value().length,
            amountOfImages: fs.readdirSync("./img").length,
            imagesSize: (size / 1024 / 1024).toFixed(2) + ' MB'
        })
    })
})

function randomFromZeroToNine(){
    return Math.floor(Math.random() * 10).toString();
}

module.exports = router