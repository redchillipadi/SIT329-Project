import paho.mqtt.client as mqtt
import json

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe("PositionCheck")


def on_message(client, userdata, msg):
    #print(str(msg.payload))
    message = msg.payload.decode()
    DictPos = json.loads(message)
    print(list(DictPos.values())[0]," , ", list(DictPos.values())[1])


client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
 
client.connect("test.mosquitto.org", 1883, 60)
client.loop_forever()