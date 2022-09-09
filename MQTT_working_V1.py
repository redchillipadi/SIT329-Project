import paho.mqtt.publish as publish
import requests
import RPi.GPIO as GPIO
import paho.mqtt.client as mqtt
import paho.mqtt.publish as publish
import time
import numpy as np

def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected success")
    else:
        print(f"Connected fail with code {rc}")

    



#GPIO Mode (BOARD / BCM)
GPIO.setmode(GPIO.BCM)

#set GPIO Pins
GPIO_TRIGGER = 23
GPIO_ECHO = 24

#set GPIO direction (IN / OUT)
GPIO.setup(GPIO_TRIGGER, GPIO.OUT)
GPIO.setup(GPIO_ECHO, GPIO.IN)

def distance():
    GPIO.output(GPIO_TRIGGER, True)

    time.sleep(0.00001)
    GPIO.output(GPIO_TRIGGER, False)

    StartTime = time.time()
    StopTime = time.time()

    while GPIO.input(GPIO_ECHO) == 0:
        StartTime = time.time()

    while GPIO.input(GPIO_ECHO) == 1:
        StopTime = time.time()
    TimeElapsed = StopTime - StartTime
    distance = (TimeElapsed * 34300) / 2

    return distance
state = "high"
connected = 0
if  __name__ == '__main__':
    try:
        av = []
        while True:
            if connected == 0:
                client = mqtt.Client() 
                client.on_connect = on_connect 
                client.connect("test.mosquitto.org", 1883, 60)
                #client.loop_forever()
                connected = 1
                
            dist = distance()
            av.append(dist)
            if len(av) > 10:
                check = np.mean(av)
                if check > 10 and check < 20 and state != "crossbar":
                    print("send mqtt - crossbar")
                    publish.single("PositionCheck", "Crossbar", hostname="test.mosquitto.org")
                    state = "crossbar"
                elif check < 10 and state != "sitting":
                    print("send mqtt - sitting")
                    publish.single("PositionCheck", "Sitting", hostname="test.mosquitto.org")
                    state = "sitting"
                elif check > 20 and state != "standing":
                    print("send mqtt - standing")
                    publish.single("PositionCheck", "Standing", hostname="test.mosquitto.org")
                    state = "standing"
                av.pop(0)

            print ("Measured Distance = %.1f cm" % dist)
            time.sleep(0.5)

    except KeyboardInterrupt:
        print("Measurement stopped by User")
        GPIO.cleanup()






