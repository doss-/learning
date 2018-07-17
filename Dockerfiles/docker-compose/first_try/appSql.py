import mysql.connector

connection = mysql.connector.connect(user='root', password='testp', host='172.17.0.2', database='testdb')

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
