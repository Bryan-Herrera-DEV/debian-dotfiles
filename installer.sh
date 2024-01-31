#!/usr/bin/env bash

CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
CBL=$(tput setaf 4)
BLD=$(tput bold)
CNC=$(tput sgr0)

backup_folder=~/.RiceBackup
date=$(date +%Y%m%d-%H%M%S)

logo () {
	local text="${1:?}"
	echo -en "                                  
      _,     ,_
    .'/  ,_   \'.
   |  \__( >__/  |
   \             /
    '-..__ __..-'
         /_\  Dotfiles de Cr1p70, basados en  Ghost1nTh3SSH/dotfiles \n\n"
    printf ' %s [%s%s %s%s %s]%s\n\n' "${CRE}" "${CNC}" "${CYE}" "${text}" "${CNC}" "${CRE}" "${CNC}"
}

########## ---------- NO root ---------- ##########
not_sudo () {
    if [ "$(id -u)" = 0 ]; then
        echo "Este script NO DEBE ejecutarse como usuario root."
        exit 1
    fi
} 

########## ---------- Bienvenida ---------- ##########
welcome () {
    logo "Bienvenido!"
    printf '%s%sEste script comprobará si tienes las dependencias necesarias, y si no, las instalará. Luego, clonará el RICE en tu directorio HOME.\nDespués, creará una copia de seguridad segura de tus archivos y, a continuación, copiará los nuevos archivos en tu ordenador.\n\nMis Dotfiles no cambian ni modifican ninguna de las configuraciones del sistema.\nSe le pedirá su contraseña de root para instalar las dependencias que faltan y/o para cambiar a zsh shell si no es tu terminal default.\n\nEste script no tiene el poder potencial para romper tu sistema, solo copia los archivos de mi repositorio en el directorio HOME.%s\n\n' "${BLD}" "${CRE}" "${CNC}"

    while true; do
        read -rp " Deseas continuar? [y/N]: " yn
            case $yn in
                [Yy]* ) break;;
                [Nn]* ) exit;;
                * ) printf " Error: Basta con escribir 'y' o 'n'\n\n";;
            esac
        done
    clear
}

# ########## ---------- Instalacion de las dependencias---------- ##########
requirements () {
    logo "Instalando requerimientos..."

    packages=(bspwm polybar kitty rofi picom sxhkd lsd feh code firejail neofetch xclip fonts-jetbrains-mono zsh zsh-syntax-highlighting flameshot net-tools)

    printf "%s%s[+] Comprobacion de los paquetes necesarios...%s\n" "${BLD}" "${CBL}" "${CNC}"
    
    for package in "${packages[@]}"
    do
        if ! apt list --installed "$package" 2>/dev/null | grep -q "$package"; then
            printf '\t- Instalando %s...%s\n' "$package"
            sudo apt install "$package" -y &> /dev/null
            
        else
            printf '\t- %s ya esta instalado en su sistema!\n' "$package"
            sleep 1            
        fi
    done
    printf '%s[+] Todos los requisitos necesarios han sido instalados!%s\n' "$CGR" "$CNC"
    sleep 3
    clear
}

########## ---------- Preparando Carpetas ---------- ##########
prepFolders () {
    logo "Preparando Carpetas"
    if [ ! -e $HOME/.config/ ]; then
        mkdir $HOME/.config/
        printf "\t- Creando $HOME/.config/..."
    else
        printf "\t- $HOME/.config/ Ya existe."
    fi
    sleep 2 
    clear
}

########## ---------- Copias a la Rice! ---------- ##########
copyRice () {
    logo "Instalando dotfiles..."
    printf "%s[+] Copiando a las rutas respectivas...\n%s" "$CBL" "$CNC"

    for folder in ./ghost-rice/*; do
        cp -R "${folder}" ~/.config/
        if [ $? -eq 0 ]; then
            printf "\t-%s carpeta copiada con exito dentro de '${HOME}/.config/'!%s\n" "${folder}" "${CNC}"
            sleep 1
        else 0 O
            printf "\t-%s%s no se ha copiado, debe copiarlo manualmente%s\n" "${CRE}" "${folder}" "${CNC}"
            sleep 1
        fi
    done

    for folder in ./misc/*; do
        cp -R -f "${folder}" ~/.local/share/fonts/
        if [ $? -eq 0 ]; then
            printf "\t-%s copiado con exito dentro de '${HOME}/.local/share/fonts/'!%s\n" "${folder}" "${CNC}"
            sleep 1
        else
            printf "\t-%s%s no se ha copiado, debe copiarlo manualmente%s\n" "${CRE}" "${folder}" "${CNC}"
            sleep 1
        fi
    done

    fc-cache -rv >/dev/null 2>&1
    printf "%s[+] Archivos copiados con exito!!%s\n" "${CGR}" "${CNC}"
    sleep 1
}

########## --------- shell a zsh pwlv10k ---------- ##########
chShell () {
    logo "Cambiar shell por defecto a zsh power10k..."

    # Download powerlevel10k
    if [ ! -d "~/.config/powerlevel10k" ]; then
        git clone --quiet --depth=1 https://gitee.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k
    fi

    # Setup P10K theme and ZSH config
    cp -f home/p10k.zsh ~/.p10k.zsh && cp -f home/zshrc ~/.zshrc

    if [ $? -eq 0 ]; then
        printf "\t-%s archivos copiados con exito dentro de tu ruta HOME!%s\n" "${file}" "${CNC}"
        sleep 1
    else
        printf "\t-%s %s no se ha copiado, debe copiarlo manualmente%s\n" "${CRE}" "${file}" "${CNC}"
        sleep 1
    fi
    # done

    printf "%s%sSi su shell no es zsh se cambiará ahora.\nSu contraseña de root es necesaria para hacer el cambio.\n\nDespués de eso es importante que reinicie.\n %s\n" "${BLD}" "${CRE}" "${CNC}"
    if [[ $SHELL != "/usr/bin/zsh" ]]; then
        echo "Changing shell to zsh, your root password is needed."
        chsh -s /usr/bin/zsh
        printf "%s%s[+] La instalación ha finalizado correctamente, ahora reinicie el sistema.\n%sGood bye!\n" "${BLD}" "${CGR}" "${CNC}"
        zsh
    else
        printf "%s%s[+] Installation finished successfully, now reboot the system.\n%sHasta la Proxima!\n" "${BLD}" "${CGR}" "${CNC}"
        zsh
    fi
}

########## ---------- Ejecucion ---------- ##########
not_sudo
welcome
requirements
prepFolders
copyRice
chShell