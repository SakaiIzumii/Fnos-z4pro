#!/bin/bash

echo "[Z4PRO] Init GPIO..."

# SATA 上电
gpioset --mode=exit gpiochip0 17=0
gpioset --mode=exit gpiochip0 16=0
gpioset --mode=exit gpiochip0 8=0
gpioset --mode=exit gpiochip0 7=0

# 电源绿灯
gpioset --mode=exit gpiochip0 100=0
gpioset --mode=exit gpiochip0 96=1
echo "[Z4PRO] Done"
