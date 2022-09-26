#include <error.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
#include <inttypes.h>

#define BRIDGE 0xC0000000
#define BRIDGE_SPAN 0x40

#define ADC_CH0 0x00
#define ADC_CH1 0x08
#define ADC_CH2 0x10
#define ADC_CH3 0x18
#define ADC_CH4 0x20
#define ADC_CH5 0x28
#define ADC_CH6 0x30
#define ADC_CH7 0x38

int main(int argc, char** argv) {
        int fd = open("/dev/mem", O_RDWR | O_SYNC);
        if (fd < 0) {
                perror("Couldn't open /dev/mem\n");
                return -1;
        }

        uint8_t* bridge_map = (uint8_t*)mmap(NULL, BRIDGE_SPAN, PROT_READ | PROT                                                                                                             _WRITE, MAP_SHARED, fd, BRIDGE);
        if (bridge_map == MAP_FAILED) {
                perror("Couldn't map bridge.\n");
                close(fd);
                return -1;
        }

        uint8_t* ch0_map = bridge_map + ADC_CH0;
        uint8_t* ch1_map = bridge_map + ADC_CH1;
        uint8_t* ch2_map = bridge_map + ADC_CH2;
        uint8_t* ch3_map = bridge_map + ADC_CH3;
        uint8_t* ch4_map = bridge_map + ADC_CH4;
        uint8_t* ch5_map = bridge_map + ADC_CH5;
        uint8_t* ch6_map = bridge_map + ADC_CH6;
        uint8_t* ch7_map = bridge_map + ADC_CH7;


        while (1) {
                uint64_t ch0 = *((uint64_t*)ch0_map);
                uint64_t ch1 = *((uint64_t*)ch1_map);
                uint64_t ch2 = *((uint64_t*)ch2_map);
                uint64_t ch3 = *((uint64_t*)ch3_map);
                uint64_t ch4 = *((uint64_t*)ch4_map);
                uint64_t ch5 = *((uint64_t*)ch5_map);
                uint64_t ch6 = *((uint64_t*)ch6_map);
                uint64_t ch7 = *((uint64_t*)ch7_map);

                printf("%" PRIu64 "\t", ch0);
                printf("%" PRIu64 "\t", ch1);
                printf("%" PRIu64 "\t", ch2);
                printf("%" PRIu64 "\t", ch3);
                printf("%" PRIu64 "\t", ch4);
                printf("%" PRIu64 "\t", ch5);
                printf("%" PRIu64 "\t", ch6);
                printf("%" PRIu64 "\n", ch7);
        }

        int result = munmap(bridge_map, BRIDGE_SPAN);
        if (result < 0) {
                perror("Couldn't unmap bridge.\n");
                close(fd);
                return -1;
        }

        close(fd);
        return 0;
}
