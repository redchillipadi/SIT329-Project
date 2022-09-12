#define ADC_ADDR 0x00005000
#define LED_ADDR 0x00005020

int main (void)
{
    volatile int* adc = (int *)(ADC_ADDR);
    volatile int* led = (int *)(LED_ADDR);
    unsigned int data = 0;
//    int count = 0;
    int channel = 0;

    //Start the ADC Auto Update
    *(adc+1) = 1;

    while (1)
    {
        data = *(adc+channel); //Get the value of the selected channel

        //Ignore the lowest 4 bits
        //Display the value on the LEDs
        data = data/16;
        *(led) = data;

	// Every 0.5 seconds, switch to the next channel
  //      count += 1;
  //      if (count==500000){
  //          count = 0;
  //          channel = (channel + 1) % 8;
  //      }
    }
    return 0;
}
