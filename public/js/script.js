function toggleMenu(){
	document.querySelector("nav").classList.toggle("show");
}

function toggleHelp(){
    document.querySelector("#help").classList.toggle("toggle");
}

function toggleAddStudent(){
    document.querySelector("#add-student").classList.toggle("toggle");
}

function toggleAddGroup(){
    document.querySelector("#add-group").classList.toggle("toggle");
}

async function quiz(){
    groupId = document.querySelector('#group-selector').value;
    await startQuiz(groupId).then(quiz => {
        sessionStorage.quiz = JSON.stringify(quiz);
    })
    getStudent();
    document.querySelector('#student').classList.remove('toggle');
}

async function getStudent(){
    let quiz = JSON.parse(sessionStorage.quiz)
    studentId = quiz['student_ids'][Math.floor(Math.random() * quiz['student_ids'].length)]
    sessionStorage.currentId = studentId
    await getStudentImage(studentId).then(image => {
        document.querySelector('#student').querySelector('img').src = image
    })
}

async function makeGuess(){
    guess = document.querySelector('#guess').value
    document.querySelector('#guess').value = ``
    await getStudentName(sessionStorage.currentId).then(name => {
        if (guess.toLowerCase() == name.toLowerCase()) {
            let quiz = JSON.parse(sessionStorage.quiz)
            quiz['correct'] += 1;
            sessionStorage.quiz = JSON.stringify(quiz)
        }
    })
    let quiz = JSON.parse(sessionStorage.quiz)
    quiz['student_ids'].splice(quiz['student_ids'].indexOf(parseInt(sessionStorage.currentId)), 1)
    sessionStorage.quiz = JSON.stringify(quiz)
    if (quiz['student_ids'].length <= 0){
        alert(`You scored ${quiz['correct']} out of ${quiz['amount']}`)
        location.reload()
    } else {
        await getStudent()
    }
}

function deleteGroupConfirm(groupId){
    getGroupName(groupId).then(groupName => {
        if (confirm(`Press OK if you wish to proceed and delete ${groupName}`) == true){
            deleteGroup(groupId);
        }
    })
}

function removeStudentConfirm(studentId){
    getStudentName(studentId).then(studentName => {
        if (confirm(`Press OK if you wish to proceed and remove ${studentName} from this group`) == true){
            removeStudent(studentId);
        }
    })
}

async function deleteGroup(groupId){
    await fetch(`http://localhost:9292/api/deletegroup/${groupId}`)
    location.reload()
}

async function removeStudent(studentId){
    await fetch(`http://localhost:9292/api/removestudent/${studentId}`)
    location.reload()
}

async function startQuiz(groupId){
    const response = await fetch(`http://localhost:9292/api/startquiz/${groupId}`)
    return response.json();
}

async function getCurrentQuiz(){
    const response = await fetch(`http://localhost:9292/api/getcurrentquiz`)
    return response.json();
}

async function getStudentImage(id){
    const response = await fetch(`http://localhost:9292/api/getstudentimage/${id}`)
    return response.json();
}

async function getStudentName(id){
    const response = await fetch(`http://localhost:9292/api/getstudentname/${id}`)
    return response.json();
}

async function getGroupName(id){
    const response = await fetch(`http://localhost:9292/api/getgroupname/${id}`)
    return response.json();
}