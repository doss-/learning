from flask import Flask

app = Flask(__name__)


from flask_wtf import Form
from wtforms import IntegerField, TextField, SubmitField

app.secret_key = 'development key'

class SubmitForm(Form):
  text_field = TextField(u'Text Field:')
  int_field = IntegerField(u'Integer Field:')
  submit = SubmitField(u'ClickMe')

from flask import render_template

#add handling of route /
@app.route("/")
def renderMe():
  submit_page = SubmitForm()
  return render_template('index.html', form=submit_page)

#display all values from db table in there


#@app.route(u'/submit', methods=[u'POST'])
#def submitMethod():
#  print("test")
#  form = SubmitForm()
#  if form.valudate_on_submit():
    
if __name__ == "__main__":
  app.run(host = '0.0.0.0')
