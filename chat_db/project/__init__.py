import os
import boto3
import json



from pyms.flask.app import Microservice
from project.models.init_db import db

class MyMicroservice(Microservice):
    
    def init_libs(self):
        db_uri = os.getenv("DB_URI") or self.application.config.get("SQLALCHEMY_DATABASE_URI")

        def get_db_password():
            client = boto3.client('secretsmanager', region_name='us-east-1')
            secret = client.get_secret_value(SecretId='ms_db_secrets')
            return json.loads(secret['SecretString'])['password']

        if not db_uri or db_uri == "sqlite://":
            db_host = os.getenv("DB_HOST")
            if db_host:
                db_port = os.getenv("DB_PORT", "3306")
                db_name = os.getenv("DB_NAME", "chatdb")
                db_user = os.getenv("DB_USER", "admin")
                db_password = get_db_password()
                db_uri = f"mysql+pymysql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"

        if db_uri:
            self.application.config["SQLALCHEMY_DATABASE_URI"] = db_uri

        db.init_app(self.application)
        with self.application.test_request_context():
            db.create_all()


def create_app():
    """Initialize the Flask app, register blueprints and intialize all libraries like Swagger, database, the trace system...
    return the app and the database objects.
    :return:
    """
    ms = MyMicroservice(path=__file__)
    
    return ms.create_app()
