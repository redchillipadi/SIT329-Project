import paho.mqtt.client as mqtt
import json
import csv
from datetime import datetime
import pandas as pd


#change path accordingly 
PATH = '/Users/nadav/Desktop/Uni/2022_tri_2/SIT329/Project/code/SIT329-Project/testingCSVfiles/'


# Takes in time and date of start of 
# session to include in CSV file name
dateTimenow = f"{datetime.now() :%Y-%m-%d_%H-%M-%S}"
NAME = f"Exercise_Log_{dateTimenow}"

# Create new CSV file 
f = open(PATH+NAME+".csv", "w", newline="")
writer = csv.writer(f)

# Add headers to CSV file
header = "POSITION" , "DURATION", "DATE", "TIME"
writer.writerow(header)

# Funtion to enable communications with the publisher,
# executed upon connection
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe("PositionCheck")

# Function to read incoming messages and decipher 
# from JSON format
def on_message(client, userdata, msg):
    # Decode message and load to a dictionary object
    message = msg.payload.decode()
    DictPos = json.loads(message)

    # Save date and time for each position instance
    date = f"{datetime.now():%Y-%m-%d}"
    time1 = f"{datetime.now():%H:%M:%S}"
    writer = csv.writer(f)

    # Flag for when the session is over to execute shutdown procedure
    if list(DictPos.values())[0] == "End of Session":
        print("Session terminated by user")
        f.close()

        #execute analytical report
        analysisReport(PATH, NAME)
        exit(0)
    # Write input data to CSV file
    else:
        temp = (list(DictPos.values())[0] , list(DictPos.values())[1], date, time1)
        writer.writerow(temp)
        print(list(DictPos.values())[0],"\t,\t", list(DictPos.values())[1])
 
# Analytical report 
def analysisReport(path, name):
    print(f"\n===== Session: {name} ======")
    address = path+name+".csv"
    df = pd.read_csv(rf'{address}')
    # new2 = (df["POSITION"].value_counts()["sitting"])
    TopTubeDuration = (df.loc[df["POSITION"] == "TopTube"].sum()["DURATION"])
    PantaniDuration = (df.loc[df["POSITION"] == "Pantani"].sum()["DURATION"])
    FroomeDuration = (df.loc[df["POSITION"] == "Froome"].sum()["DURATION"])
    ElbowsDuration = (df.loc[df["POSITION"] == "Elbows"].sum()["DURATION"])

    Total = TopTubeDuration + PantaniDuration + FroomeDuration + ElbowsDuration
    print("\n_____Totals are:______ "+
        "\nTopTube: \t %.2f"%TopTubeDuration+
        "\nPantani: \t %.2f"%PantaniDuration+
        "\nFroome: \t %.2f"%FroomeDuration+
        "\nElbows: \t %.2f"%ElbowsDuration+
        "\nTotal: \t \t %.2f"%Total)
    
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
 
client.connect("test.mosquitto.org", 1883, 60)
client.loop_forever()