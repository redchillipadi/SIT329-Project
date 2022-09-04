# Sensor configuration analysis

The capacitive sensor that the team is building must have different configurations to adjust the sensitivity. These experiments are run with different configuations to identify the correct circuit for different locations.

## Findings

| Test | Resistor | Capacitor | Touch | Proximity |
| ---- | -------- | --------- | ----- | --------- |
| 00   | 100k     | -         | 🚫    | 🚫        |
| 01   | 100k     | 221k      | ✅    | 🚫        |
| 02   | 100k     | 680k      | ✅    | 🚫        |
| 03   | 100k     | 560k      | ✅    | 🚫        |
| 04   | 10M      | -         | ✅    | 🚫        |
| 05   | 10M      | 221k      | ✅    | 🚫        |
| 06   | 10M      | 681k      | ✅    | 🚫        |
| 07   | 20M      | -         | ✅    | 🚫        |
| 08   | 20M      | 221k      | ✅    | 🟡        |
| 09   | 20M      | 681k      | ✅    | 🟡        |
| 10   | 30M      | -         | ✅    | 🟡        |
| 11   | 30M      | 221k      | ✅    | 🟡        |
| 12   | 50M      | 221k      | ✅    | ✅        |
| 13   | 50M      | 681k      | 🚫    | 🚫        |
| 14   | 80M      | 221k      | ✅    | ✅        |
| 15   | 80M      | 681k      | 🚫    | 🚫        |

## Data logs
### Test 00
![Test](./Diagrams/TEST00.CSV.png)

### Test 01
![Test](./Diagrams/TEST01.CSV.png)

### Test 02
![Test](./Diagrams/TEST02.CSV.png)

### Test 03
![Test](./Diagrams/TEST03.CSV.png)

### Test 04
![Test](./Diagrams/TEST04.CSV.png)

### Test 05
![Test](./Diagrams/TEST05.CSV.png)

### Test 06
![Test](./Diagrams/TEST06.CSV.png)

### Test 07
![Test](./Diagrams/TEST07.CSV.png)

### Test 08
![Test](./Diagrams/TEST08.CSV.png)

### Test 09
![Test](./Diagrams/TEST09.CSV.png)

### Test 10
![Test](./Diagrams/TEST10.CSV.png)

### Test 11
![Test](./Diagrams/TEST11.CSV.png)

### Test 12
![Test](./Diagrams/TEST12.CSV.png)

### Test 13
![Test](./Diagrams/TEST13.CSV.png)

### Test 14
![Test](./Diagrams/TEST14.CSV.png)

### Test 15
![Test](./Diagrams/TEST15.CSV.png)
