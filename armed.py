# the purpose of this Python file is to convert the readings from the ultrasonic sensor 
# and store them. This allows us to compare two values and see if any movement has occured
# If there is movement, record.sh (camera recording) will begin. 
import serial
import time
import subprocess
import re

# set up the serial line
ser = serial.Serial('/dev/ttyACM0', 9600)
time.sleep(2)

# Read and record the data
data = []                                        # empty list to store the data (string)
data_int = []                                    # empty list to store the data (integers)
while(True):                            
    b = ser.readline()                           # read a byte string                          
    string_n = b.decode()                        # decode byte string into Unicode
    string = string_n.rstrip()                   # remove \n and \r
    print(string)                                

    number_array = re.findall(r'\d+', string)    # Extracting only numbers from the string
 
    if len(number_array) > 1:                    # ensure both cm and inch values appear in the array
        centimeter = int(number_array[1])        # turning the value in cm into a int
        data_int.append(centimeter)              # add the integer to the end of data_int list


        if len(data_int) > 2:                    # ensure there are at least two measurements        
            first = data_int[len(data_int) - 6]  # finds the first measurement
            second = data_int[len(data_int) - 1] # finds the second measurement
            if abs(second - first) > 3:          # checks if the difference is greater than 3cm
               print("Motion has been detected")
               subprocess.call('/home/victor/Desktop/camera_automation/record.sh')
               break;
    data.append(string)
    time.sleep(0.1)
ser.close()
