import paho.mqtt.publish as publish
import requests
import RPi.GPIO as GPIO
import paho.mqtt.client as mqtt
import paho.mqtt.publish as publish
from timeit import default_timer as timer
import time
import numpy as np
from datetime import timedelta

def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected success")
    else:
        print(f"Connected fail with code {rc}")

    
Position = ["sitting", "standing" , "crossbar" ]

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

def publishState(newState, currentState, timerLapsed):
    
    temp = " %.2f" % timerLapsed
    publish.single("PositionCheck", "position " + str(currentState)+ " >> " + temp +  "   New position: " + str(newState), hostname="test.mosquitto.org")
    start = 0
    
    
state = Position[0]
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
                # start timer to check each state duration   
                start = timer()
            
            dist = distance()
            av.append(dist)
            if len(av) > 20:
                check = np.mean(av)
                if check > 10 and check < 20 and state != Position[2]:
                    print("send mqtt -" + Position[2])
                    end = timer()
                    endTime = end - start
                    publishState(Position[2],  state, endTime)
                    state = Position[2]
                    
                elif check < 10 and state != Position[1]:
                    print("send mqtt -" + Position[1])
                    end = timer()
                    endTime = end - start
                    publishState(Position[1],  state, endTime)
                    state = Position[1]

                elif check > 20 and state != Position[0]:
                    print("send mqtt -" + Position[0])
                    end = timer()
                    endTime = end - start
                    publishState(Position[0],  state, endTime)
                    state = Position[0]
                    
                av.pop(0)

            print ("Measured Distance = %.1f cm" % dist)
            time.sleep(0.1)

    except KeyboardInterrupt:
        print("Measurement stopped by User")
        publish.single("PositionCheck", "End of Session", hostname="test.mosquitto.org")

        GPIO.cleanup()






