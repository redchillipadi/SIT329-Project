import paho.mqtt.client as mqtt


def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe("PositionCheck")


        
# check payload
def on_message(client, userdata, msg):
    print(str(msg.payload))
    message = msg.payload.decode()
    # if "sitting" in message:
    #     print("User is at low position")

    # if msg.payload == "crossbar":
    #     print("User is at mid position")

    # if msg.payload == "standing":
    #     print("User is at high position")

# connent to publisher
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
 
client.connect("test.mosquitto.org", 1883, 60)
client.loop_forever()
