#include "altera_up_avalon_parallel_port.h"
#include "altera_up_avalon_adc.h"

int main(void)
{
    alt_up_parallel_port_dev* led =
        alt_up_parallel_port_open_dev("/dev/Green_LEDs");
    alt_up_adc_dev* adc = alt_up_adc_open_dev("/dev/ADC");
    unsigned int data = 0;
    int count = 0;
    int channel = 0;

    while (led != NULL && adc != NULL)
    {
        alt_up_adc_update(adc);
        count++;
        data = alt_up_adc_read(adc, channel);
        data = data / 16;
        alt_up_parallel_port_write_data(led, data);
        if (count==500000)
        {
            count = 0;
            channel = !channel;
        }
    }

    return 0;
}
