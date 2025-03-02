#!/bin/bash

# =============================
#      MENÚ DE AUTOMATIZACIÓN
# =============================

while true; do
    clear
    echo "===================================="
    echo "        MENU DE AUTOMATIZACIÓN      "
    echo "===================================="
    echo "1) Mostrar datos de red"
    echo "2) Ver estado del servicio"
    echo "3) Instalar PulseAudio"
    echo "4) Eliminar PulseAudio"
    echo "5) Iniciar PulseAudio"
    echo "6) Detener PulseAudio"
    echo "7) Consultar logs"
    echo "8) Editar configuración"
    echo "9) Salir"
    echo "===================================="
    
    read -p "Seleccione una opción: " opcion

    case $opcion in
        1)
            echo "Mostrando datos de red..."
            ip a
            read -p "Presiona Enter para continuar..."
            ;;
        
        2)
            echo "Verificando estado de PulseAudio..."
            systemctl --user status pulseaudio
            read -p "Presiona Enter para continuar..."
            ;;
        
        3)
            echo "Seleccione el método de instalación:"
            echo "1) Con comandos"
            echo "2) Con Ansible"
            echo "3) Con Docker"
            read -p "Ingrese una opción: " metodo

            if [ "$metodo" == "1" ]; then
                echo "Instalando PulseAudio con comandos..."
                sudo apt update && sudo apt install -y pulseaudio pavucontrol pulseaudio-utils
                echo "✅ PulseAudio instalado correctamente."

            elif [ "$metodo" == "2" ]; then
                echo "Instalando PulseAudio con Ansible..."
                ansible-playbook -i inventory audio.yaml
                echo "✅ Instalación con Ansible completada."

            elif [ "$metodo" == "3" ]; then
                echo "Descargando la imagen de PulseAudio desde Docker Hub..."
                docker pull gaboooox/docker_audio_gabo:latest  # Reemplaza con el nombre correcto si es otro
                echo "✅ Imagen descargada correctamente."
                echo "------------------------------------------"
                echo "📝 Para ejecutar el contenedor manualmente, usa el siguiente comando:"
                echo ""
                echo "   docker run -d --name pulseaudio_gabo --privileged gabo/pulseaudio:latest"
                echo ""
                echo "⚠️  Luego, puedes acceder al contenedor con: docker exec -it pulseaudio_gabo /bin/bash"
                echo "------------------------------------------"
            else
                echo "❌ Opción inválida."
            fi
            read -p "Presiona Enter para continuar..."
            ;;
        
        4)
            echo "Eliminando PulseAudio..."
            sudo apt remove --purge -y pulseaudio pavucontrol pulseaudio-utils
            echo "✅ PulseAudio eliminado."
            read -p "Presiona Enter para continuar..."
            ;;
        
        5)
            echo "Iniciando PulseAudio..."
            pulseaudio --start 
            echo "✅ PulseAudio iniciado."
            read -p "Presiona Enter para continuar..."
            ;;
        
        6)
            echo "Deteniendo PulseAudio..."
            pulseaudio -k
            echo "✅ PulseAudio detenido."
            read -p "Presiona Enter para continuar..."
            ;;
        
        7)
            echo "Seleccione cómo desea consultar los logs:"
            echo "1) Por fecha"
            echo "2) Por tipo (error, warning, info)"
            echo "3) Mostrar últimos 20 logs"
            echo "4) Volver al menú"
            read -p "Ingrese una opción: " log_opcion

            case $log_opcion in
                1)
                    read -p "Ingrese la fecha en formato YYYY-MM-DD: " fecha
                    journalctl --user -u pulseaudio --since "$fecha" --no-pager
                    ;;
                2)
                    read -p "Ingrese el tipo de log (error, warning, info): " tipo
                    journalctl --user -u pulseaudio --grep "$tipo" --no-pager
                    ;;
                3)
                    echo "Mostrando los últimos 20 logs de PulseAudio..."
                    journalctl --user -u pulseaudio --no-pager | tail -n 20
                    ;;
                4)
                    echo "Volviendo al menú..."
                    ;;
                *)
                    echo "❌ Opción inválida."
                    ;;
            esac
            read -p "Presiona Enter para continuar..."
            ;;
        
        8)
            echo "Editando configuración de PulseAudio..."
            nano ~/.config/pulse/default.pa
            echo "✅ Configuración guardada."
            read -p "Presiona Enter para continuar..."
            ;;
        
        9)
            echo "Saliendo del script..."
            exit 0
            ;;
        
        *)
            echo "❌ Opción inválida, intenta de nuevo."
            read -p "Presiona Enter para continuar..."
            ;;
    esac
done

