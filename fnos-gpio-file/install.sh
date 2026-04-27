#!/bin/bash
#!/bin/bash

set -e

echo "==== Z4Pro GPIO Install ===="

# ========= 0. 必须 root =========
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root!"
  exit 1
fi

# ========= 1. 基础依赖 =========
echo "[1/6] Installing gpiod..."
apt update
apt install -y gpiod

# ========= 2. 检查文件 =========
echo "[2/6] Checking files..."

[ -f "z4pro-init.sh" ] || { echo "Missing z4pro-init.sh"; exit 1; }
[ -f "rc.local" ] || { echo "Missing rc.local"; exit 1; }
[ -f "pinctrl-alderlake.ko" ] || { echo "Missing pinctrl-alderlake.ko"; exit 1; }

# ========= 3. 安装内核模块 =========
echo "[3/6] Installing pinctrl driver..."

KVER=$(uname -r)
MODDIR="/lib/modules/$KVER/kernel/drivers/pinctrl/intel"

mkdir -p $MODDIR

cp pinctrl-alderlake.ko $MODDIR/

depmod -a

# 避免重复加载报错
if ! lsmod | grep -q pinctrl_alderlake; then
  modprobe pinctrl-alderlake || echo "modprobe failed (check dmesg)"
fi

# ========= 4. 安装主脚本 =========
echo "[4/6] Installing init script..."

cp z4pro-init.sh /usr/local/bin/
chmod +x /usr/local/bin/z4pro-init.sh

# ========= 5. 安装 rc.local（安全方式） =========
echo "[5/6] Installing rc.local..."

if [ -f /etc/rc.local ]; then
  echo "rc.local exists, backing up..."
  cp /etc/rc.local /etc/rc.local.bak
fi

cp rc.local /etc/rc.local
chmod +x /etc/rc.local

systemctl enable rc-local 2>/dev/null || true

# ========= 6. 完成 =========
echo "[6/6] Install done!"
echo "Reboot recommended."

echo "[TEST] Checking GPIO..."

if ls /dev/gpiochip* >/dev/null 2>&1; then
  echo "GPIO OK"
else
  echo "GPIO NOT FOUND"
fi
