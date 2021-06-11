from datetime import datetime
import urllib.request
import mysql.connector
import time
import json

dew_api = "http://<ip>:<port>/"

databuff = ""

dewdb = mysql.connector.connect(
        host="<db-ip>",
        user="dew",
        password="",
        database="dewrito"
    )

dewcursor = dewdb.cursor()


try:
    dewcursor.execute("CREATE TABLE dewrito (date DATETIME, servername VARCHAR(2                                                                                                                                                             55),  status VARCHAR(255), map VARCHAR(255), variant VARCHAR(255), players INT,                                                                                                                                                              playtime INT)")

except:
    print("Table already exists (or something actually bad happened), ignoring..                                                                                                                                                             .")

def server_meta():
    while True:
        try:
            with urllib.request.urlopen(dew_api) as url:
                data = json.loads(url.read().decode())

                return data

        except:
            print("Could not connect to the dewrito meta data api.")
            time.sleep(1)
            continue

        break


def main():

    databuff = server_meta()
    timeflag = True

    while True:
        start = time.time()
        timeflag = True

        while timeflag == True:
            data = server_meta()

            if data["status"] != databuff["status"]:
                playtime = time.time() - start
                dtnow = datetime.now()
                date_time = dtnow.strftime("%Y/%m/%d, %H:%M:%S")

                print("New event detected, saving previous round.")

                sql = "INSERT INTO dewrito (date, servername, status, map, varia                                                                                                                                                             nt, players, playtime) VALUES (%s, %s, %s, %s, %s, %s, %s)"

                sqldata = (date_time, "Your Server Name Here", d                                                                                                                                                             atabuff["status"], databuff["map"], databuff["variantType"], databuff["numPlayer                                                                                                                                                             s"], playtime)

                dewcursor.execute(sql, sqldata)
                dewdb.commit()

                databuff = data
                timeflag = False
                time.sleep(1)

            else:
                time.sleep(1)

main()
