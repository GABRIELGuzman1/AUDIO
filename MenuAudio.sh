#!/bin/bash

# Función para mostrar los datos de red del equipo
function datos_red() {
    echo "Datos de red del equipo:"
    echo "Dirección IP: $(hostname -I | awk '{print $1}')"
    echo "Hostname: $(hostname)"
    echo "--------------------------------------"
}

# Función para verificar el estado del servicio PulseAudio
function estado_servicio() {
    echo "Estado del servicio PulseAudio:"
    systemctl --user status pulseaudio | grep -E 'Active|Loaded'
    echo "--------------------------------------"
}

# Función para instalar el servicio
function instalar_servicio() {
    case $1 in
        comandos)
            echo "Instalando PulseAudio con comandos..."
            sudo apt update && sudo apt install -y pulseaudio pavucontrol paprefs pulseaudio-utils
            ;;
        ansible)
            echo "Verificando si Ansible está instalado..."
            if ! command -v ansible &> /dev/null; then
                echo "Ansible no está instalado. Instalándolo ahora..."
                sudo apt update && sudo apt install -y ansible
            fi
            echo "Ejecutando playbook de Ansible..."
            ansible-playbook -i hosts audio.yaml
            ;;
        docker)
            echo "Instalando PulseAudio con Docker..."
            docker run -d --name pulseaudio-server -p 4713:4713 tuusuario/pulseaudio-server
            ;;
        *)
            echo "Opción inválida. Usa: instalar [comandos|ansible|docker]"
            exit 1
            ;;
    esac
}

# Función para eliminar el servicio
function eliminar_servicio() {
    echo "Eliminando PulseAudio..."
    sudo apt remove --purge -y pulseaudio
}

# Función para iniciar el servicio
function iniciar_servicio() {
    echo "Iniciando PulseAudio..."
    pulseaudio --start
}

# Función para detener el servicio
function detener_servicio() {
    echo "Deteniendo PulseAudio..."
    pulseaudio -k
}

# Función para consultar logs
function consultar_logs() {
    case $1 in
        fecha)
            read -p "Ingrese la fecha (YYYY-MM-DD): " fecha
            journalctl --user -u pulseaudio --since "$fecha"
            ;;
        tipo)
            read -p "Ingrese el tipo de log (error, warning, info): " tipo
            journalctl --user -u pulseaudio | grep -i "$tipo"
            ;;
        todos)
            journalctl --user -u pulseaudio
            ;;
        *)
            echo "Opción inválida. Usa: logs [fecha|tipo|todos]"
            exit 1
            ;;
    esac
}

# Función para editar la configuración
function editar_configuracion() {
    echo "Editando configuración de PulseAudio..."
    sudo nano /etc/pulse/default.pa
}

# Mostrar datos de red y estado del servicio al iniciar el script
datos_red
estado_servicio

# Verificar argumentos y ejecutar la acción correspondiente
if [ $# -lt 1 ]; then
    echo "Uso: $0 [acción] [opción]"
    echo ""
    echo "Acciones disponibles:"
    echo "  instalar [comandos|ansible|docker]   - Instalar PulseAudio con el método elegido"
    echo "  eliminar                            - Eliminar PulseAudio"
    echo "  iniciar                             - Iniciar PulseAudio"
    echo "  detener                             - Detener PulseAudio"
    echo "  logs [fecha|tipo|todos]             - Consultar logs"
    echo "  editar                              - Editar configuración de PulseAudio"
    echo ""
    exit 1
fi

case $1 in
    instalar)
        if [ -z "$2" ]; then
            echo "Debes especificar el método de instalación. Usa: instalar [comandos|ansible|docker]"
            exit 1
        fi
        instalar_servicio "$2"
        ;;
    eliminar)
        eliminar_servicio
        ;;
    iniciar)
        iniciar_servicio
        ;;
    detener)
        detener_servicio
        ;;
    logs)
        if [ -z "$2" ]; then
            echo "Debes especificar el tipo de logs. Usa: logs [fecha|tipo|todos]"
            exit 1
        fi
        consultar_logs "$2"
        ;;
    editar)
        editar_configuracion
        ;;
    *)
        echo "Opción inválida. Usa: $0 [acción] [opción]"
        exit 1
        ;;
esac
