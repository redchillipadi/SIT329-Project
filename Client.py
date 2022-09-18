import paho.mqtt.client as mqtt
import json
import csv
from datetime import datetime

datenow = str(datetime.now())
name = "Exercise_Log:" + datenow
f = open(name, "a", newline="")

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe("PositionCheck")


def on_message(client, userdata, msg):
    #print(str(msg.payload))
    message = msg.payload.decode()
    if message == "End of Session":
        print(message)
        f.close()
    DictPos = json.loads(message)

 
    date = datetime.now().date()
    time1 = datetime.now().time()
    temp = (list(DictPos.values())[0] , list(DictPos.values())[1], date, time1)
    writer = csv.writer(f)
    writer.writerow(temp)
    print(list(DictPos.values())[0]," , ", list(DictPos.values())[1])



client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
 
client.connect("test.mosquitto.org", 1883, 60)
client.loop_forever()       