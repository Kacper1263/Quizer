//Check are required packages installed
try{
    require('express')
    require('body-parser')
    require('fs')
    require('path')
    require('lowdb')
    require('readline-sync')
    require('localtunnel')
}catch(e){
    return console.log(`\n   You don't have required packages! \n\n   Use "npm i" to install them! \n\n`)
}

const express = require('express')
const bodyParser = require('body-parser')
const fs = require('fs')
const path = require('path')
const readline = require('readline-sync')
const lt = require('localtunnel')

//#region Config variables
var localtunnelEnabled = false;
var tunnelUrlList = []
var adminPassword = randomFromZeroToNine() + randomFromZeroToNine() + randomFromZeroToNine() + randomFromZeroToNine() //Generate 4 random numbers
var databaseName = "questions"
//#endregion

//#region Get data from config
try{
    var cfg = fs.readFileSync("./config.json")
    cfg = JSON.parse(cfg)
    localtunnelEnabled = cfg.localtunnelEnabled
    tunnelUrlList = cfg.tunnelUrlList
    adminPassword = cfg.adminPassword
    databaseName = cfg.databaseName
}catch(e){
    //Create config if not exist
    if(!fs.existsSync("./config.json")){
        var data = {
            localtunnelEnabled: localtunnelEnabled,
            tunnelUrlList: tunnelUrlList,
            adminPassword: adminPassword,
            databaseName: databaseName
        }
        data = JSON.stringify(data, null, 2)
        fs.writeFileSync("./config.json", data)
        console.log("Config file created, you can now edit it")
        return readline.keyInPause("\nProgram ended...")
    }else{
        console.log("Error occurred: " + e + "\n\nYou can try to delete config file")
        return readline.keyInPause("\nProgram ended...")
    }
}
//#endregion

const low = require('lowdb')
const FileSync = require('lowdb/adapters/FileSync') 
const adapter = new FileSync(`${databaseName}.json`)
const db = low(adapter)


function randomFromZeroToNine(){
    return Math.floor(Math.random() * 10).toString();
}