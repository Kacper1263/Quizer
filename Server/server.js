//Check are required packages installed
try {
    require('express')
    require('body-parser')
    require('fs')
    require('path')
    require('lowdb')
    require('readline-sync')
    require('localtunnel')
    require('get-folder-size')
} catch (e) {
    return console.log(`\n   You don't have required packages! \n\n   Use "npm i" to install them! \n\n`)
}

const express = require('express')
const bodyParser = require('body-parser')
const fs = require('fs')
const readline = require('readline-sync')

//#region Config variables
var localtunnelEnabled = false;
var tunnelUrl = ""
var adminPassword = randomFromZeroToNine() + randomFromZeroToNine() + randomFromZeroToNine() + randomFromZeroToNine() //Generate 4 random numbers
var databaseName = "questions"
var apiPort = 5000;
var tunnelPort = 5000
//#endregion

//#region Get data from config
try {
    var cfg = fs.readFileSync("./config.json")
    cfg = JSON.parse(cfg)
    localtunnelEnabled = cfg.localtunnelEnabled
    tunnelUrl = cfg.tunnelUrl
    adminPassword = cfg.adminPassword
    databaseName = cfg.databaseName
    apiPort = cfg.apiPort
    tunnelPort = cfg.tunnelPort
} catch (e) {
    //Create config if not exist
    if (!fs.existsSync("./config.json")) {
        var data = {
            localtunnelEnabled: localtunnelEnabled,
            tunnelUrl: tunnelUrl,
            adminPassword: adminPassword,
            databaseName: databaseName,
            apiPort: apiPort,
            tunnelPort: tunnelPort
        }
        data = JSON.stringify(data, null, 2)
        fs.writeFileSync("./config.json", data)
        console.log("Config file created, you can now edit it")
        return readline.keyInPause("\nProgram ended...")
    } else {
        console.log("Error occurred: " + e + "\n\nYou can try to delete config file")
        return readline.keyInPause("\nProgram ended...")
    }
}
//#endregion

const localtunnel = require('localtunnel')
var tunnelSubdomain = tunnelUrl || ""
if (tunnelSubdomain != "") var tunnelUrlUWant = `https://${tunnelSubdomain}.localtunnel.me`; //Full url for verification is domain in use

//#region localtunnel stuff
if (localtunnelEnabled) {
    console.log("Starting API and tunnel... (keep in mind that you may not add a new question with photo to the database via localtunnel due to the file size limit!)")
    var tunnel = localtunnel(tunnelPort, { subdomain: tunnelSubdomain}, function (err, tunnel) {
        if (err) {
            console.log("Error while creating tunnel: " + err);
            readline.keyInPause("\nProgram ended...")
            process.exit();
        }

        console.log("Tunnel started with url: " + tunnel.url + " on port: " + tunnelPort);

        if (tunnelSubdomain == "") tunnelUrlUWant = tunnel.url

        if (tunnel.url != tunnelUrlUWant) {
            console.log("Error! Subdomain in use!");
            readline.keyInPause("\nProgram ended...")
            process.exit();
        }

        console.log("");
    });
    tunnel.on('close', function () {
        console.log("Tunnel closed!");
        readline.keyInPause("\nProgram ended...")
        process.exit();
    });
    var restartingTunnel = false;
    tunnel.on('error', function (err) {
        if (restartingTunnel) return;
        restartingTunnel = true;
        console.log("Error on tunnel. Err: " + err);
        console.log();
        console.log("Restarting tunnel...");

        tunnel = localtunnel(tunnelPort, { subdomain: tunnelSubdomain }, function (err, tunnel) {
            if (err) {
                console.log("Error while creating tunnel: " + err);
                readline.keyInPause("\nProgram ended...")
                process.exit();
            }

            console.log("Tunnel started with url: " + tunnel.url + " on port: " + tunnelPort);

            if (tunnel.url != tunnelUrlUWant) {
                console.log("Error! Subdomain in use!");
                readline.keyInPause("\nProgram ended...")
                process.exit();
            }

            console.log("");
            restartingTunnel = false;
        });
    });
}
else{
    console.log("Starting only API...")
}
//#endregion

const low = require('lowdb')
const FileSync = require('lowdb/adapters/FileSync')
const adapter = new FileSync(`${databaseName}.json`)
const db = low(adapter)

// *****************************
// *   API starts from there   *
// *****************************

db.defaults({ questions: [] }).write() //default variables for database

// Set up the express app
const app = express();
app.use(bodyParser.json({limit: '50mb'}));
app.use(bodyParser.urlencoded({limit: '50mb', extended: true}));

//Routes API v1
var routes_v1 = require('./routes/v1/index')
app.use("/api/v1/status", routes_v1.status)
app.use("/api/v1/apk", express.static('apk')) 
app.use("/api/v1/questions", routes_v1.questions)
app.use("/api/v1/admin", routes_v1.admin)
app.use("/api/v1/img", express.static('img'))

//404
app.use(function (req, res) {
    res.status(404).send({ success: 'false', code: 404, message: "Page not found! Bad API route!" });
});

app.listen(process.env.PORT || apiPort, () => {
    console.log(`API running on port ${process.env.PORT || apiPort}`)
});


function randomFromZeroToNine() {
    return Math.floor(Math.random() * 10).toString();
}