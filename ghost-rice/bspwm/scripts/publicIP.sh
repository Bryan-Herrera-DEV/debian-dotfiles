#!/bin/bash

# Ejecuta curl y guarda el resultado
output=$(curl --silent ipv4.icanhazip.com)

# Define un patrón para una dirección IPv4 (formato básico)
ipv4_pattern='[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'

# Verifica si curl se ejecutó exitosamente y si la salida coincide con el patrón de una dirección IPv4
if [ $? -eq 0 ] && [[ $output =~ $ipv4_pattern ]]; then
    echo "$output"
else
    echo "192.168.1.1"
fi

