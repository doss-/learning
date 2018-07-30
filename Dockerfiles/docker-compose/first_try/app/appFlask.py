# http://docs.sqlalchemy.org/en/rel_0_9/dialects/mysql.html#module-sqlalchemy.dialects.mysql.mysqlconnector
# mysql wrappers.. seems like i need one anyway
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

dbuser = "testu"
dbpasswd = "testpass"
dbserver = "mysql_server"
dbname = "testdb"
dburi = "mysql://{}:{}@{}/{}".format(dbuser, dbpasswd, dbserver, dbname)
print("dburi: {}".format(dburi))

# see here for basic SQLAlchemy start
# http://flask-sqlalchemy.pocoo.org/2.3/quickstart/#quickstart
# here for detailed Models examples and docs
# http://flask-sqlalchemy.pocoo.org/2.3/models/#models
# here for detailed data manipulations
# http://flask-sqlalchemy.pocoo.org/2.3/queries/#inserting-records
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = dburi 
db = SQLAlchemy(app)

class User(db.Model):
  __tablename__ = 't'
  name = db.Column('c', db.CHAR(20))
  uid = db.Column('ci', db.INTEGER, primary_key=True)

#import WTForms
from flask_wtf import FlaskForm
from wtforms import IntegerField, StringField, SubmitField

app.secret_key = 'development key'

class SubmitForm(FlaskForm):
  text_field = StringField("Text Field:")
  int_field = IntegerField(u'Integer Field:')
  submit_button = SubmitField(u'ClickMe!')

from flask import render_template

#add handling of route /
@app.route("/")
def renderMe():
  submit_page = SubmitForm()
  return render_template('index.html', form=submit_page)

#display all values from db table in there


@app.route(u'/submit', methods=[u'POST'])
def submitMethod():
  form = SubmitForm()
  user_info = User(name=form.text_field.data, uid=form.int_field.data)

  if form.validate_on_submit():
   print("in if")
   db.session.add(user_info)
   db.session.commit()
   return "text field:{} ; int field:{}".format(form.text_field.data, form.int_field.data)
  print(form.errors)
  print("after if")
  return render_template('index.html', form=form)
    
if __name__ == "__main__":
  app.run(host = '0.0.0.0')
