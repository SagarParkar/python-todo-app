from flask import Flask, render_template, request, redirect, url_for, jsonify
import sqlite3
from pathlib import Path

cwd = Path.cwd()
path_to_db = str(cwd) + "/data/data.db"
print("Current directory path:", path_to_db)

conn = sqlite3.connect(path_to_db,check_same_thread=False)

app = Flask(__name__)

#with sqlite3.connect(path_to_db,check_same_thread=False) as conn:
    #conn.execute('''CREATE TABLE IF NOT EXISTS items (id INTEGER PRIMARY KEY, name TEXT, status TEXT)''')
    #conn.commit()
conn.execute('''CREATE TABLE IF NOT EXISTS items (id INTEGER PRIMARY KEY, name TEXT, status TEXT)''')
conn.commit()


# in-memory storage for tasks

#tasks = []

#[conn.execute('SELECT json_agg(my_table) FROM my_table'),conn.execute('SELECT status FROM items')]

# home page
@app.route('/')
def home():
    cursor = conn.cursor()
    cursor.execute('SELECT id, name, status FROM items')
    tasks = cursor.fetchall()
    #print("Current directory path:", cwd)
    #for task in tasks:
        #print(task[0])
        #print(task[1])
        #print(task[2])
    #for row in result_set:
    #    print(row)
    return render_template('index.html', tasks=tasks)

# add a new task
@app.route('/add', methods=['POST'])
def add():
    task = request.form['task']
    #tasks.append({'name': task, 'completed': False})
    #print(task)
    #conn.execute('''CREATE TABLE IF NOT EXISTS items (id INTEGER PRIMARY KEY, name TEXT, status TEXT)''')
    conn.execute('INSERT INTO items (name, status) VALUES (?, ?)', (task, False))
    conn.commit()
    return redirect(url_for('home'))

# mark a task as completed
@app.route('/complete/<int:index>')
def complete(index):
    #tasks[index]['completed'] = True
    conn.execute('UPDATE items SET status = ? WHERE id = ?', (True, index))
    conn.commit()
    return redirect(url_for('home'))

# mark a task as incomplete
@app.route('/incomplete/<int:index>')
def incomplete(index):
    #tasks[index]['completed'] = False
    conn.execute('UPDATE items SET status = ? WHERE id = ?', (False, index))
    conn.commit()
    return redirect(url_for('home'))

# delete a task
@app.route('/delete/<int:index>', methods=['DELETE', 'GET'])
def delete(index):
    #del tasks[index]
    conn.execute('DELETE FROM items WHERE id = ?', (index,))
    conn.commit()
    return redirect(url_for('home'))

if __name__ == '__main__':
    #app.run(debug=True)
    app.run(host='0.0.0.0', port=5000)
