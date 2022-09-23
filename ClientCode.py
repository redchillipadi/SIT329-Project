import paho.mqtt.client as mqtt
import json
import csv
from datetime import datetime
import pandas as pd

#change path accordingly 
PATH = '/Users/nadav/Desktop/Uni/2022_tri_2/SIT329/Project/code/SIT329-Project/testingCSVfiles/'

dateTimenow = f"{datetime.now() :%Y-%m-%d_%H-%M-%S}"
NAME = f"Exercise_Log_{dateTimenow}"
f = open(PATH+NAME+".csv", "w", newline="")
writer = csv.writer(f)
header = "POSITIO" , "TIME", "DATE", "TIME"
writer.writerow(header)

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe("PositionCheck")


def on_message(client, userdata, msg):
    #print(str(msg.payload))
    message = msg.payload.decode()
    
    DictPos = json.loads(message)

    date = f"{datetime.now():%Y-%m-%d}"
    time1 = f"{datetime.now():%H:%M:%S}"
    # date = datetime.now().date()
    # time1 = datetime.now().time()
    writer = csv.writer(f)
    if list(DictPos.values())[0] == "End of Session":
        result = "Session terminated by user"
        print(result)
        temp = result , 0, date, time1
        writer.writerow(temp)
        f.close()
        analysisReport(PATH, NAME)

        exit(0)
    else:
        temp = (list(DictPos.values())[0] , list(DictPos.values())[1], date, time1)
        writer.writerow(temp)
        print(list(DictPos.values())[0]," , ", list(DictPos.values())[1])



#yet to work. needs adjusting
# def average_column (csv):
#     f = open(csv,"r")
#     average = 0
#     Sum = 0
#     row_count = 0
#     for row in f:
#         for column in row.split(','):
#             n=float(column)
#             Sum += n
#         row_count += 1
#     average = Sum / len(column)
#     f.close()
#     return 'The average is:', average 


def analysisReport(path, name):
    print("TIME NOW: " , name)
    address = path+name+".csv"
    df = pd.read_csv(rf'{address}')
    count1 = df['POSITION'].count()
    print(df)
    print(f"Count {count1}")
    
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
 
client.connect("test.mosquitto.org", 1883, 60)
client.loop_forever()
    
# new file
