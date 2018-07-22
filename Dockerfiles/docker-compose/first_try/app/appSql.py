import mysql.connector
import time

def tryConnect(counter, sleep_time):
  connected = None

  while(not connected):
    if (counter <= 0):
      break
    try:
      print("Py Conn: trying to connect to db")
      connection = mysql.connector.connect(user='testu', password='testpass', host='mysql_server', database='testdb')
      connected = True
    except mysql.connector.errors.InterfaceError as interface_error:
      print("Py Conn: python cant connect to db")
      if (sleep_time > 0):
        time.sleep(sleep_time)
        print("Py Conn: sleeping for {} seconds".format(sleep_time))
      counter -= 1
      print("Py Conn: retries left {}".format(counter))

#probably could return shit if connection fails at all
  return connection

if __name__ == "__main__":
  
  connection = tryConnect(155, 5)
  print("after the connection")
  
  cursor = connection.cursor()
  
  #set up data to insert
  query = ("insert testdb.t (c) values ({})")
  values = ("from python script")
  
  #insert the data
  #cursor.execute(query.format(values))
  cursor.execute("insert testdb.t (c) values ('from python script')")
  
  #commit the data
  connection.commit()
  
  #dispose all
  cursor.close()
  connection.close()
  
  print("after the connection close")
