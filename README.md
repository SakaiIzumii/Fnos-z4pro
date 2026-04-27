# Fnos-z4pro
z4pro 性能版硬盘笼在 Fnos 下的驱动.
仅测试了硬盘笼,在1.1.26版本下的测试.  
理论上支持官方在6.12.18-trim下的所有更新包.  

led灯暂时只驱动了第四盘位以及电源指示灯,  
第四盘位:gpio 96.电源指示灯 gpio 99(红色) 100(绿色) 同时开启为黄色指示灯.  

下载目录并且解压  
cd fnos-gpio-file  
chmod +x install.sh  
./install.sh  
reboot  
