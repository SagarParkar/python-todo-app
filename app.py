from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# in-memory storage for tasks
tasks = []

# home page
@app.route('/')
def home():
    return render_template('index.html', tasks=tasks)

# add a new task
@app.route('/add', methods=['POST'])
def add():
    task = request.form['task']
    tasks.append({'name': task, 'completed': False})
    return redirect(url_for('home'))

# mark a task as completed
@app.route('/complete/<int:index>')
def complete(index):
    tasks[index]['completed'] = True
    return redirect(url_for('home'))

# mark a task as incomplete
@app.route('/incomplete/<int:index>')
def incomplete(index):
    tasks[index]['completed'] = False
    return redirect(url_for('home'))

# delete a task
#@app.route('/delete/<int:index>')
#def delete(index):
#    del tasks[index]
#    return redirect(url_for('home'))

# delete a task
@app.route('/delete/<int:index>', methods=['DELETE', 'GET'])
def delete(index):
    del tasks[index]
    return redirect(url_for('home'))

# edit a task
#


if __name__ == '__main__':
    #app.run(debug=True)
    app.run(host='0.0.0.0', port=5000)
