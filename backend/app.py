from flask import Flask, request, jsonify, redirect, render_template
from dotenv import load_dotenv
import os
import psycopg2
from flask_cors import CORS


load_dotenv()

app = Flask(__name__)
CORS(app)

def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS")
    )

@app.route("/")
def root_redirect():
    # Redirect to your S3 static site or frontend URL
    return redirect(os.getenv("FRONTEND_URL", "http://sachit-frontend.s3-website-us-east-1.amazonaws.com"), code=302)

@app.route("/create-tables")
def create_tables():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            CREATE TABLE IF NOT EXISTS feedback (
                id SERIAL PRIMARY KEY,
                name TEXT NOT NULL,
                message TEXT NOT NULL,
                submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
        """)
        conn.commit()
        cur.close()
        conn.close()
        return {"status": "success", "message": "Tables created successfully"}
    except Exception as e:
        return {"status": "error", "message": str(e)}, 500

@app.route("/create-db")
def create_db():
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST"),
            database="postgres",
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASS")
        )
        conn.autocommit = True
        cur = conn.cursor()
        cur.execute("CREATE DATABASE sachit;")
        cur.close()
        conn.close()
        return {"status": "success", "message": "Database 'sachit' created"}
    except Exception as e:
        return {"status": "error", "message": str(e)}, 500

@app.route("/submit-feedback", methods=["POST"])
def submit_feedback():
    data = request.get_json()
    name = data.get('name')
    message = data.get('message')

    if not name or not message:
        return jsonify({"error": "Name and message are required"}), 400

    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO feedback (name, message) VALUES (%s, %s)",
            (name, message)
        )
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"status": "success", "message": "Feedback submitted"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/get-feedback", methods=["GET"])
def get_feedback():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT id, name, message, submitted_at FROM feedback ORDER BY submitted_at DESC;")
        rows = cur.fetchall()
        cur.close()
        conn.close()

        feedback_list = [
            {"id": row[0], "name": row[1], "message": row[2], "submitted_at": row[3].strftime('%Y-%m-%d %H:%M:%S')}
            for row in rows
        ]
        return jsonify(feedback_list)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0", port=5000)
