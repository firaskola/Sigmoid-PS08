from flask import Flask, request, jsonify, session
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import and_
from flask_login import LoginManager, UserMixin, login_user, login_required, current_user, logout_user
from datetime import datetime, time, timezone
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)

app.config['SECRET_KEY'] = 'my key'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
app.config['SESSION_TYPE'] = 'filesystem'
app.config['SESSION_COOKIE_HTTPONLY'] = True

db = SQLAlchemy(app)
login_manager = LoginManager(app)

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    firstname = db.Column(db.String(150), nullable=False)
    lastname = db.Column(db.String(150), nullable=False)
    email = db.Column(db.String(300), unique=True, nullable=False)
    password = db.Column(db.String(150), nullable=False)
    role = db.Column(db.String(50), nullable=False, default='Elder')

class Medicine(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    name = db.Column(db.String(500), nullable=False)
    time_morning = db.Column(db.Time, nullable=True)  # Morning time to take the medicine
    time_evening = db.Column(db.Time, nullable=True)  # Evening time to take the medicine
    time_night = db.Column(db.Time, nullable=True)    # Night time to take the medicine
    instructions = db.Column(db.String(500), nullable=True)  # Instructions for taking medicine
    timestamp = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))






@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

@app.route('/register', methods=['POST'])
def register():
    firstname = request.json.get('firstname')
    lastname = request.json.get('lastname')
    email = request.json.get('email')
    password = request.json.get('password')
    role = request.json.get('role', 'Elder')  # Default to 'Elder' if not specified

    # Validation
    if not firstname or not lastname or not email or not password:
        return jsonify({'message': 'all-fields-required'}), 400

    if len(password) < 4:
        return jsonify({'message': 'password-length-invalid'}), 400

    if User.query.filter_by(email=email).first():
        return jsonify({'message': 'email-exists'}), 400

    # Hash the password
    hashed_password = generate_password_hash(password)

    # Create new user
    new_user = User(
        firstname=firstname,
        lastname=lastname,
        email=email,
        password=hashed_password,
        role=role
    )
    db.session.add(new_user)
    db.session.commit()

    return jsonify({'message': 'user-register-success'}), 201

@app.route('/login', methods=['POST'])
def login():
    email = request.json.get('email')
    password = request.json.get('password')
    
    if not email or not password:
        return jsonify({'message': 'email-and-password-required'}), 400

    user = User.query.filter_by(email=email).first()
    
    if user and check_password_hash(user.password, password):
        login_user(user)
        session['user_id'] = user.id
        return jsonify({'message': 'login-success'}), 200
    
    return jsonify({'message': 'invalid-creds'}), 401

@app.route('/add_medicine', methods=['POST'])
@login_required
def add_medicine():
    name = request.json.get('name')
    time_morning = request.json.get('time_morning')  # Should be in "HH:MM:SS" format or null if not set
    time_evening = request.json.get('time_evening')
    time_night = request.json.get('time_night')
    instructions = request.json.get('instructions')

    # Validation
    if not name:
        return jsonify({'message': 'medicine-name-required'}), 400

    # Convert times to time objects if provided
    try:
        time_morning = datetime.strptime(time_morning, '%H:%M:%S').time() if time_morning else None
        time_evening = datetime.strptime(time_evening, '%H:%M:%S').time() if time_evening else None
        time_night = datetime.strptime(time_night, '%H:%M:%S').time() if time_night else None
    except ValueError:
        return jsonify({'message': 'invalid-time-format'}), 400

    # Create new medicine entry
    new_medicine = Medicine(
        user_id=current_user.id,
        name=name,
        time_morning=time_morning,
        time_evening=time_evening,
        time_night=time_night,
        instructions=instructions
    )
    db.session.add(new_medicine)
    db.session.commit()

    return jsonify({'message': 'medicine-added-successfully'}), 201

@app.route('/get_medicines', methods=['GET'])
@login_required
def get_medicines():
    # Retrieve all medicines for the currently logged-in user
    medicines = Medicine.query.filter_by(user_id=current_user.id).all()

    # Convert medicines to a list of dictionaries
    medicines_list = [
        {
            'id': medicine.id,
            'name': medicine.name,
            'time_morning': medicine.time_morning.strftime('%H:%M:%S') if medicine.time_morning else None,
            'time_evening': medicine.time_evening.strftime('%H:%M:%S') if medicine.time_evening else None,
            'time_night': medicine.time_night.strftime('%H:%M:%S') if medicine.time_night else None,
            'instructions': medicine.instructions,
            'timestamp': medicine.timestamp.isoformat()  # Format timestamp as ISO string
        }
        for medicine in medicines
    ]

    return jsonify(medicines_list), 200

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(host='0.0.0.0', port=5000, debug=True)
