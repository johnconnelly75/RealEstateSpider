#!/usr/bin/python

import time
from datetime import datetime
import MySQLdb

ts = datetime.today()
print "Connecting to DB at time:", ts

# Open database connection
db = MySQLdb.connect("localhost","scrapydb","denied957","realestatedb" )

# prepare a cursor object using cursor() method
cursor = db.cursor()

# execute SQL query using execute() method.
cursor.execute("SELECT VERSION()")

# Fetch a single row using fetchone() method.
data = cursor.fetchone()

print "Database version : %s " % data

# disconnect from server
db.close()


i = 0
urlsa = (1,2,3)
while i < 3:
    print urlsa[i]
    i = i + 1



