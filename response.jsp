<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Response Page</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        .response-container { border: 2px solid #000; padding: 10px; margin-top: 20px; background: #f9f9f9; display: inline-block; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Words You Have Entered</h1>

        <div class="response-container">
            <ul id="taskList">
                <%
                    // Retrieve session list or create a new one
                    java.util.List<String> words = (java.util.List<String>) session.getAttribute("wordsList");
                    if (words == null) {
                        words = new java.util.ArrayList<>();
                        session.setAttribute("wordsList", words);
                    }
                %>
            </ul>
        </div>

        <br>
        <a href="index.jsp">Go Back</a>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            let storedTasks = JSON.parse(sessionStorage.getItem('tasks')) || [];
            let taskList = document.getElementById("taskList");

            if (storedTasks.length === 0) {
                taskList.innerHTML = "<li>No tasks added yet.</li>";
            } else {
                storedTasks.forEach(task => {
                    let li = document.createElement("li");
                    li.textContent = task;
                    taskList.appendChild(li);
                });
            }
        });
    </script>
</body>
</html>
