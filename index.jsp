<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cool Interactive Page</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; transition: background 0.3s, color 0.3s; }
        .dark-mode { background: #222; color: white; }
        .container { margin: 20px auto; width: 80%; max-width: 600px; }
        button { margin: 10px; padding: 10px; cursor: pointer; }
        ul { list-style-type: none; padding: 0; }
        li { background: #eee; margin: 5px; padding: 5px; cursor: pointer; }
        .response-box { border: 2px solid #000; padding: 10px; margin-top: 20px; background: #f9f9f9; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Cool Interactive Features</h1>
        <button onclick="toggleDarkMode()">Toggle Dark Mode</button>
        <button onclick="fetchJoke()">Get Random Joke</button>
        <button onclick="applyFilter()">Change Image Filter</button>
        <button onclick="sendPostRequest()">Send POST Request</button>
        <input type="color" onchange="changeBgColor(event)">
        <h2 id="clock"></h2>
        <p id="joke">Click the button to get a joke.</p>

        <h3>To-Do List</h3>
        <input type="text" id="todoInput" placeholder="New task...">
        <button onclick="addTask()">Add</button>
        <ul id="todoList"></ul>

        <br>
        <!-- Form to send user input to response.jsp -->
        <form action="response.jsp" method="get">
            <button type="submit">Show Response Page</button>
        </form>

        <!-- Box to display all response words -->
        <h3>Saved Words</h3>
        <div class="response-box">
            <ul id="savedWordsList">
                <li>No words added yet.</li>
            </ul>
        </div>
        <button onclick="clearWords()">Clear Word List</button>

    </div>

    <script>
        function toggleDarkMode() {
            document.body.classList.toggle('dark-mode');
        }

        function fetchJoke() {
    fetch('https://v2.jokeapi.dev/joke/Any')
        .then(response => {
            if (!response.ok) {
                throw new Error("Failed to fetch joke");
            }
            return response.json();
        })
        .then(data => {
            const jokeElement = document.getElementById('joke');
            
            if (data.type === "twopart") {
                // If the joke has a setup and a delivery
                jokeElement.textContent = `${data.setup} - ${data.delivery}`;
            } else if (data.type === "single") {
                // If the joke is a single-line joke
                jokeElement.textContent = data.joke;
            } else {
                jokeElement.textContent = "No joke found. Try again!";
            }
        })
        .catch(error => {
            document.getElementById('joke').textContent = "Could not fetch joke. Try again!";
        });
}


        function applyFilter() {
            const filters = ['grayscale(100%)', 'sepia(100%)', 'blur(5px)', 'brightness(150%)', 'contrast(200%)', 'none'];
            document.getElementById('image').style.filter = filters[Math.floor(Math.random() * filters.length)];
        }

        function changeBgColor(event) {
            document.body.style.background = event.target.value;
        }

        function updateClock() {
            document.getElementById('clock').textContent = new Date().toLocaleTimeString();
        }
        setInterval(updateClock, 1000);

        function addTask() {
            const taskInput = document.getElementById('todoInput');
            if (taskInput.value.trim() !== '') {
                const li = document.createElement('li');
                li.textContent = taskInput.value;
                li.onclick = () => li.remove();
                document.getElementById('todoList').appendChild(li);
                
                // Store task in sessionStorage so response.jsp can read it
                let storedTasks = JSON.parse(sessionStorage.getItem('tasks')) || [];
                storedTasks.push(taskInput.value);
                sessionStorage.setItem('tasks', JSON.stringify(storedTasks));

                // Update the saved words box
                updateSavedWordsDisplay();

                taskInput.value = '';
            }
        }

        function updateSavedWordsDisplay() {
            let savedWords = JSON.parse(sessionStorage.getItem('tasks')) || [];
            let savedWordsList = document.getElementById("savedWordsList");

            // Clear the existing list
            savedWordsList.innerHTML = "";

            if (savedWords.length === 0) {
                savedWordsList.innerHTML = "<li>No words added yet.</li>";
            } else {
                savedWords.forEach(task => {
                    let li = document.createElement("li");
                    li.textContent = task;
                    savedWordsList.appendChild(li);
                });
            }
        }

       function clearWords() {
            sessionStorage.removeItem('tasks'); // Clear stored words
            document.getElementById('todoList').innerHTML = ''; // Clear UI list
            updateSavedWordsDisplay(); // Refresh UI
        }

        function sendPostRequest() {
            const url = "https://jsonplaceholder.typicode.com/posts";
            const payload = {
                title: "Test Post",
                body: "This is a test payload for a POST request.",
                userId: 1
            };

            fetch(url, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-Custom-Header": "TestHeaderValue"
                },
                body: JSON.stringify(payload)
            })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => { throw new Error(text) });
                }
                return response.json();
            })
            .then(data => {
                document.getElementById('responseMessage').textContent = `Post created with ID: ${data.id}`;
            })
            .catch(error => {
                document.getElementById('responseMessage').textContent = `Error: ${error.message}`;
            });
        }

        // Load saved words on page load
        document.addEventListener("DOMContentLoaded", updateSavedWordsDisplay);
    </script>
</body>
</html>
