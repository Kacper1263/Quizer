const express = require('express')
const fs = require('fs')
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

router.get("/all", (req, res) => {
    db.read()
    res.status(200).send({
        success: "true",
        message: "OK",
        content: db.get("questions").value()
    })
})

//Return 10 random questions
router.get("/", (req, res) => {
    db.read()
    var questions = db.get("questions").value();

    // Check are 10 questions in DB
    if(questions.length < 10){
        return res.status(500).send({
            success: "false",
            message: "There are less than 10 questions in the database!"
        })
    }

    var randomQuestions = []
    var randomNumbers = []

    for(var i = 1; i<=10; i++){
        var randomNumber

        // Generate random number that not exists in array to prevent questions duplicate
        while(true){
            randomNumber = Math.floor(Math.random() * questions.length)
            if(!randomNumbers.includes(randomNumber)) break
        }

        randomNumbers.push(randomNumber)

        var id = questions[randomNumber].id
        var question = questions[randomNumber].question
        var img = questions[randomNumber].img
        var answer1 = questions[randomNumber].answer1
        var answer2 = questions[randomNumber].answer2
        var answer3 = questions[randomNumber].answer3
        var answer4 = questions[randomNumber].answer4
        var goodAnswer = questions[randomNumber].goodAnswer

        randomQuestions.push({id: id, question: question, img: img, answer1: answer1, answer2: answer2, answer3: answer3, answer4: answer4, goodAnswer: goodAnswer})
    }    
    
    return res.status(200).send({
        success: "true",
        message: "Random questions received",
        content: randomQuestions
    })
})

router.post("/", (req,res) => {
    db.read()
    
    //To prevent ID duplication after removing a few old ones, each new ID will be 1 greater than the ID of the last object on the list.
    var list = db.get("questions").value();
    var lastObject = list[list.length - 1];
    var newID;
    if(lastObject == undefined){
        newID = 1;
    }
    else{
        newID = lastObject.id + 1;
    }
    const question = {
        id: newID,
        question: req.body.question,
        img: req.body.img,
        answer1: req.body.answer1,
        answer2: req.body.answer2,
        answer3: req.body.answer3,
        answer4: req.body.answer4,
        goodAnswer: req.body.goodAnswer
    }

    db.get("questions").push(question).write();
    return res.status(201).send({
        success: 'true',
        message: 'Question added successfully',
        content: question
    })
})

function randomFromZeroToNine(){
    return Math.floor(Math.random() * 10).toString();
}

module.exports = router
