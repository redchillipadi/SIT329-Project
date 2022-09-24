from os import stat
import paho.mqtt.publish as publish
import requests
# import RPi.GPIO as GPIO
import paho.mqtt.client as mqtt
import paho.mqtt.publish as publish
from timeit import default_timer as timer
import time
import numpy as np
from datetime import timedelta
import json
import random

def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected success")
    else:
        print(f"Connected fail with code {rc}")
Position = ["topTube", "Pantani" ,"Froome", "Elbows"]

# #GPIO Mode (BOARD / BCM)
# GPIO.setmode(GPIO.BCM)
# #set GPIO Pins
# GPIO_TRIGGER = 23
# GPIO_ECHO = 24
# #set GPIO direction (IN / OUT)
# GPIO.setup(GPIO_TRIGGER, GPIO.OUT)
# GPIO.setup(GPIO_ECHO, GPIO.IN)

# def distance():
#     GPIO.output(GPIO_TRIGGER, True)
#     time.sleep(0.00001)
#     GPIO.output(GPIO_TRIGGER, False)
#     StartTime = time.time()
#     StopTime = time.time()
#     while GPIO.input(GPIO_ECHO) == 0:
#         StartTime = time.time()
#     while GPIO.input(GPIO_ECHO) == 1:
#         StopTime = time.time()
#     TimeElapsed = StopTime - StartTime
#     distance = (TimeElapsed * 34300) / 2
#     return distance

drops_sensor = random.randint(1, 2)
hoods_sensor = 0
front_sensor = random.randint(1, 2)
rear_sensor = 0
top_sensor = random.randint(1, 2)

def publishState(newState, currentState, timerLapsed):
    posDict = {"positon":"topTube", "time":0 }
    temp = " %.2f" % timerLapsed
    posDict.update({"positon":currentState, "time":temp })
    toSend = json.dumps(posDict)
    publish.single("PositionCheck", toSend , hostname="test.mosquitto.org")
global start
state = Position[0]
connected = 0
if  __name__ == '__main__':
    try:
        av1 = []
        av2 = []
        av3 = []
        av4 = []
        av5 = []
        while True:
            if connected == 0:
                client = mqtt.Client() 
                client.on_connect = on_connect 
                client.connect("test.mosquitto.org", 1883, 60)
                #client.loop_forever()
                connected = 1
                # start timer to check each state duration   
                start = time.time()
            dist_ds = drops_sensor
            dist_hs = hoods_sensor
            dist_fs = front_sensor
            dist_rs = rear_sensor
            dist_ts = top_sensor

            av1.append(dist_ds)
            av2.append(dist_hs)
            av3.append(dist_fs)
            av4.append(dist_rs)
            av5.append(dist_ts)

            if len(av1) > 20 or len(av2) > 20 or len(av3) > 20 or len(av4) > 20 or len(av5) > 20:
                check_ds = np.mean(av1)
                check_hs = np.mean(av2)
                check_fs = np.mean(av3)
                check_rs = np.mean(av4)
                check_ts = np.mean(av5)
                if (check_ds > 0 and check_ds < 3) and (check_fs > 0 and check_fs < 3) and (check_rs > 0 and check_rs < 3) and check_hs == 0 and check_ts == 0 and state != Position[0]:
                    print("send mqtt -" + Position[0])
                    end = time.time()
                    endTime = end - start
                    publishState(Position[0],  state, endTime)
                    start = end
                    state = Position[0] #TopTube
                elif (check_ds > 0 and check_ds < 3) and (check_ts > 0 and check_ts < 3) and check_hs == 0 and check_fs == 0 and check_rs == 0 and state != Position[1]:
                    print("send mqtt -" + Position[1])
                    end = time.time()
                    endTime = end - start
                    publishState(Position[1],  state, endTime)
                    start = end
                    state = Position[1] #Pantani
                elif (check_ds > 0 and check_ds < 3) and (check_fs > 0 and check_fs < 3) and (check_ts > 0 and check_ts < 3) and check_hs == 0 and check_rs == 0 and state != Position[2]:
                    print("send mqtt -" + Position[1])
                    end = time.time()
                    endTime = end - start
                    publishState(Position[2],  state, endTime)
                    start = end
                    state = Position[2] #Froome
                elif (check_hs > 0 and check_hs < 3) and (check_ts > 0 and check_ts < 3) and check_ds == 0 and check_fs == 0 and check_rs == 0 and state != Position[3]:
                    print("send mqtt -" + Position[3])
                    end = time.time()
                    endTime = end - start
                    publishState(Position[3],  state, endTime)
                    start = end
                    state = Position[3] #Elbows
                av1.pop(0)
                av2.pop(0)
                av3.pop(0)
                av4.pop(0)
                av5.pop(0)
            print ("Measured Distance on Drops Sensor = %.1f cm" % dist_ds)
            print ("Measured Distance on Hoods Sensor = %.1f cm" % dist_hs)
            print ("Measured Distance on Front Sensor = %.1f cm" % dist_fs)
            print ("Measured Distance on Rear Sensor = %.1f cm" % dist_rs)
            print ("Measured Distance on Top Sensor = %.1f cm" % dist_ts)
            time.sleep(0.1)

    except KeyboardInterrupt:
        print("Measurement stopped by User")
        publish.single("PositionCheck", "End of Session", hostname="test.mosquitto.org")
        # GPIO.cleanup()
        