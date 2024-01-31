#!/usr/bin/env bash

# Ejecuta ifconfig, redirige errores a /dev/null, y guarda el resultado
ip=$(/usr/sbin/ifconfig eth0 2>/dev/null | grep "inet " | awk '{print $2}')

# Verifica si la cadena de comandos fue exitosa
if [ $? -eq 0 ] && [ -n "$ip" ]; then
    echo "$ip"
else
    echo "0.0.0.0"
fi
