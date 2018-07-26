from flask import Flask

app = Flask(__name__)


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
  #if form.valudate_on_submit():
  return_message = "text field:{} ; int field:{}".format(form.text_field, form.int_field)
  return return_message
    
if __name__ == "__main__":
  app.run(host = '0.0.0.0')
