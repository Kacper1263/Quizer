//! Version config
const appVersionMajor = 1;
const appVersionMinor = 1;
const appVersionPATCH = 0;
const appVersion = `${appVersionMajor}.${appVersionMinor}.${appVersionPATCH}`;
/// Version config

const express = require('express')
const fs = require('fs')
const folderSize = require('get-folder-size')
const router = express.Router()

var databaseName = "questions"

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
            imagesSize: (size / 1024 / 1024).toFixed(2) + ' MB',
            serverVersion: appVersion
        })
    })
})

function randomFromZeroToNine(){
    return Math.floor(Math.random() * 10).toString();
}

module.exports = router