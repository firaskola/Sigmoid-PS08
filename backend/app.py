from flask import Flask, request, jsonify, session, url_for
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, login_required, current_user, logout_user
from datetime import datetime, timezone
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename
import cloudinary
import cloudinary.uploader
import os

app = Flask(__name__)

# Configurations
app.config['SECRET_KEY'] = 'my key'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
app.config['SESSION_TYPE'] = 'filesystem'
app.config['SESSION_COOKIE_HTTPONLY'] = True
app.config['UPLOAD_FOLDER'] = 'uploads'  # Folder to temporarily save uploaded files

db = SQLAlchemy(app)
login_manager = LoginManager(app)

cloudinary.config(
    cloud_name='dfr9yu2mi',
    api_key='999488851942618',
    api_secret='-SbXYOVyMIKfSnrFj6SWFxlSoAQ'
)

# Models
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
    time_morning = db.Column(db.Time, nullable=True)
    time_evening = db.Column(db.Time, nullable=True)
    time_night = db.Column(db.Time, nullable=True)
    instructions = db.Column(db.String(500), nullable=True)
    timestamp = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

class MedicalHistory(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    report_name = db.Column(db.String(500), nullable=False)
    report_image = db.Column(db.String(500), nullable=False)
    timestamp = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))


class Appointment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    doctor_name = db.Column(db.String(150), nullable=False)
    appointment_datetime = db.Column(db.DateTime, nullable=False)
    hospital_name = db.Column(db.String(150), nullable=False)
    timestamp = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))




# Login Manager
@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# Routes

# Register Route
@app.route('/register', methods=['POST'])
def register():
    firstname = request.json.get('firstname')
    lastname = request.json.get('lastname')
    email = request.json.get('email')
    password = request.json.get('password')
    role = request.json.get('role', 'Elder')

    if not firstname or not lastname or not email or not password:
        return jsonify({'message': 'all-fields-required'}), 400

    if len(password) < 4:
        return jsonify({'message': 'password-length-invalid'}), 400

    if User.query.filter_by(email=email).first():
        return jsonify({'message': 'email-exists'}), 400

    hashed_password = generate_password_hash(password)

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

# Login Route
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

# Add Medicine Route
@app.route('/add_medicine', methods=['POST'])
@login_required
def add_medicine():
    name = request.json.get('name')
    time_morning = request.json.get('time_morning')
    time_evening = request.json.get('time_evening')
    time_night = request.json.get('time_night')
    instructions = request.json.get('instructions')

    if not name:
        return jsonify({'message': 'medicine-name-required'}), 400

    try:
        time_morning = datetime.strptime(time_morning, '%H:%M:%S').time() if time_morning else None
        time_evening = datetime.strptime(time_evening, '%H:%M:%S').time() if time_evening else None
        time_night = datetime.strptime(time_night, '%H:%M:%S').time() if time_night else None
    except ValueError:
        return jsonify({'message': 'invalid-time-format'}), 400

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

# Get Medicines Route
@app.route('/get_medicines', methods=['GET'])
@login_required
def get_medicines():
    medicines = Medicine.query.filter_by(user_id=current_user.id).all()

    medicines_list = [
        {
            'id': medicine.id,
            'name': medicine.name,
            'time_morning': medicine.time_morning.strftime('%H:%M:%S') if medicine.time_morning else None,
            'time_evening': medicine.time_evening.strftime('%H:%M:%S') if medicine.time_evening else None,
            'time_night': medicine.time_night.strftime('%H:%M:%S') if medicine.time_night else None,
            'instructions': medicine.instructions,
            'timestamp': medicine.timestamp.isoformat()
        }
        for medicine in medicines
    ]

    return jsonify(medicines_list), 200

# Delete Medicine Route
@app.route('/delete_medicine/<int:medicine_id>', methods=['DELETE'])
@login_required
def delete_medicine(medicine_id):
    # Find the medicine record by its ID and ensure it belongs to the current user
    medicine = Medicine.query.filter_by(id=medicine_id, user_id=current_user.id).first()

    if medicine:
        db.session.delete(medicine)
        db.session.commit()
        return jsonify({'message': 'medicine-deleted-successfully'}), 200

    return jsonify({'message': 'medicine-not-found'}), 404


# Upload Report Route
@app.route('/upload_report', methods=['POST'])
@login_required
def upload_report():
    if 'report_image' not in request.files:
        return jsonify({'message': 'no-file-part'}), 400

    file = request.files['report_image']
    report_name = request.form.get('report_name')

    if not report_name or file.filename == '':
        return jsonify({'message': 'report-name-and-file-required'}), 400

    # Upload the file to Cloudinary
    try:
        upload_result = cloudinary.uploader.upload(file)
        report_image_url = upload_result['secure_url']
    except Exception as e:
        return jsonify({'message': 'cloudinary-upload-failed', 'error': str(e)}), 500

    new_report = MedicalHistory(
        user_id=current_user.id,
        report_name=report_name,
        report_image=report_image_url
    )
    db.session.add(new_report)
    db.session.commit()

    return jsonify({'message': 'report-uploaded-successfully'}), 201

# Get Reports Route
@app.route('/get_reports', methods=['GET'])
@login_required
def get_reports():
    reports = MedicalHistory.query.filter_by(user_id=current_user.id).all()

    reports_list = [
        {
            'id': report.id,
            'report_name': report.report_name,
            'report_image': report.report_image,
            'timestamp': report.timestamp.isoformat()
        }
        for report in reports
    ]

    return jsonify(reports_list), 200

# Delete Report Route
@app.route('/delete_report/<int:report_id>', methods=['DELETE'])
@login_required
def delete_report(report_id):
    report = MedicalHistory.query.filter_by(id=report_id, user_id=current_user.id).first()

    if report:
        # Delete the report image from Cloudinary (optional, based on your use case)
        cloudinary.uploader.destroy(report.report_image.split('/')[-1])

        db.session.delete(report)
        db.session.commit()
        return jsonify({'message': 'report-deleted-successfully'}), 200

    return jsonify({'message': 'report-not-found'}), 404


@app.route('/add_appointment', methods=['POST'])
@login_required
def add_appointment():
    doctor_name = request.json.get('doctor_name')
    appointment_datetime = request.json.get('appointment_datetime')
    hospital_name = request.json.get('hospital_name')

    if not doctor_name or not appointment_datetime or not hospital_name:
        return jsonify({'message': 'all-fields-required'}), 400

    try:
        # Convert appointment_datetime from string to datetime object
        appointment_datetime = datetime.strptime(appointment_datetime, '%Y-%m-%d %H:%M:%S')
    except ValueError:
        return jsonify({'message': 'invalid-datetime-format'}), 400

    new_appointment = Appointment(
        user_id=current_user.id,
        doctor_name=doctor_name,
        appointment_datetime=appointment_datetime,
        hospital_name=hospital_name
    )
    db.session.add(new_appointment)
    db.session.commit()

    return jsonify({'message': 'appointment-added-successfully'}), 201


# Get Appointments Route
@app.route('/get_appointments', methods=['GET'])
@login_required
def get_appointments():
    appointments = Appointment.query.filter_by(user_id=current_user.id).all()

    appointments_list = [
        {
            'id': appointment.id,
            'doctor_name': appointment.doctor_name,
            'appointment_datetime': appointment.appointment_datetime.strftime('%Y-%m-%d %H:%M:%S'),
            'hospital_name': appointment.hospital_name,
            'timestamp': appointment.timestamp.isoformat()
        }
        for appointment in appointments
    ]

    return jsonify(appointments_list), 200


# Delete Appointment Route
@app.route('/delete_appointment/<int:appointment_id>', methods=['DELETE'])
@login_required
def delete_appointment(appointment_id):
    appointment = Appointment.query.filter_by(id=appointment_id, user_id=current_user.id).first()

    if appointment:
        db.session.delete(appointment)
        db.session.commit()
        return jsonify({'message': 'appointment-deleted-successfully'}), 200

    return jsonify({'message': 'appointment-not-found'}), 404





if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(host='0.0.0.0', port=5000, debug=True)
