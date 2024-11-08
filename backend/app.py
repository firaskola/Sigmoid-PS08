from flask import Flask,request,jsonify,session
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import and_
import cloudinary
import cloudinary.uploader
from flask_login import LoginManager, UserMixin, login_user, login_required, current_user, logout_user
from datetime import datetime


import base64
import wget 
from werkzeug.security import generate_password_hash,check_password_hash



app = Flask(__name__)


app.config['SECRET_KEY'] = 'my key'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
app.config['SESSION_TYPE'] = 'filesystem'
app.config['SESSION_COOKIE_HTTPONLY'] = True

db = SQLAlchemy(app)
login_manager = LoginManager(app)

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key = True)
    firstname = db.Column(db.String(150), unique = True, nullable=False)
    lastname = db.Column(db.String(150), unique = True, nullable=False)
    password = db.Column(db.String(150), nullable = False)
    email = db.Column(db.String(300))
    role = db.Column(db.String(50), nullable=False, default='elder')
    
    


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


@app.route('/register', methods=['POST'])
def register():
    username = request.json.get('username')
    password = request.json.get('password')

    if not username or not password:
        return jsonify({'message': 'username-and-password-required'}), 400
    
    if len(username) < 3 or len(username) > 20:
        return jsonify({'message': 'username-length-invalid'}), 400

    if len(password) < 8:
        return jsonify({'message': 'password-length-invalid'}), 400

    if User.query.filter_by(username=username).first():
        return jsonify({'message': 'username-exists'}), 400

    hashed_password = generate_password_hash(password)

    new_user = User(username=username, password=hashed_password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({'message': 'user-register-success'}), 201


@app.route('/login', methods=['POST'])
def login():
    username = request.json.get('username')
    password = request.json.get('password')
    
    if not username or not password:
        return jsonify({'message': 'username-and-password-required'}), 400

    user = User.query.filter_by(username=username).first()
    
    if user and check_password_hash(user.password, password):
        login_user(user)
        session['user_id'] = user.id
        return jsonify({'message': 'login-success'}), 200
    
    return jsonify({'message': 'invalid-creds'}), 401

