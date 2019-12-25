const express = require('express')
const fs = require('fs')
const router = express.Router()

//#region Config variables
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

router.post("/", (req, res) => {
    db.read()
    if(req.body.password == adminPassword){
        res.status(200).send({
            success: "true",
            message: "OK"
        })
    }
    else{
        res.send({
            success: "false",
            message: "Bad password"
        })
    }
    
})

function randomFromZeroToNine(){
    return Math.floor(Math.random() * 10).toString();
}

module.exports = router