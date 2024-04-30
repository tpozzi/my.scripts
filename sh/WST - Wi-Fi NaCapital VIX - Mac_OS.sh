#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$(id -u)" != "0" ]; then
    echo "Este script deve ser executado como root"
    exit 1
fi

# Define o nome da rede wireless e a senha
network_name="JOGAJUNTO"
network_password="6w4gCm\!e7xB"

# Procura por interfaces de rede sem fio disponíveis
wireless_interfaces=$(networksetup -listallhardwareports | grep -A 1 Wi-Fi | grep Device | awk '{print $2}')

# Verifica se há pelo menos uma interface sem fio disponível
if [ -z "$wireless_interfaces" ]; then
    echo "Nenhuma interface sem fio encontrada"
    exit 1
fi

# Itera sobre as interfaces sem fio e adiciona a rede especificada
for interface in $wireless_interfaces; do
    echo "Adicionando a rede $network_name à interface $interface"
    networksetup -addpreferredwirelessnetworkatindex "$interface" "$network_name" 0 WPA2 "$network_password"
done

echo "Configuração concluída"
