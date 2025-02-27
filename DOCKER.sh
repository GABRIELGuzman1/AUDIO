#!/bin/bash

# Función para mostrar ayuda
mostrar_ayuda() {
    echo "Uso: ext_docker.sh [-l] [-c contenedor] [--help|-h]"
    echo "  -l       Lista los contenedores en ejecución."
    echo "  -c       Gestiona un contenedor específico (iniciar o detener)."
    echo "  --help, -h  Muestra esta ayuda."
    exit 0
}

# Verificar si Docker está instalado
verificar_docker() {
    if ! command -v docker &>/dev/null; then
        echo "❌ Docker no está instalado."
        exit 1
    fi
}

# Listar contenedores en ejecución
listar_contenedores() {
    verificar_docker
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
}

# Gestionar un contenedor específico
gestionar_contenedor() {
    verificar_docker
    read -p "Ingrese el nombre del contenedor a gestionar: " contenedor

    if ! docker inspect "$contenedor" &>/dev/null; then
        echo "❌ El contenedor '$contenedor' no existe."
        exit 1
    fi

    estado=$(docker inspect -f '{{.State.Running}}' "$contenedor")

    if [[ "$estado" == "true" ]]; then
        read -p "¿Desea detenerlo? (s/n): " respuesta
        [[ "$respuesta" == "s" ]] && docker stop "$contenedor" && echo "✅ Contenedor detenido."
    else
        read -p "¿Desea iniciarlo? (s/n): " respuesta
        [[ "$respuesta" == "s" ]] && docker start "$contenedor" && echo "✅ Contenedor iniciado."
    fi
}

# --- PROCESAMIENTO DE ARGUMENTOS ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        -l) listar_contenedores; exit 0 ;;
        -c) gestionar_contenedor; exit 0 ;;
        --help|-h) mostrar_ayuda ;;
        *) echo "❌ Opción inválida: $1"; mostrar_ayuda; exit 1 ;;
    esac
    shift
done

# Si no se pasa ningún argumento, mostrar versión de Docker
verificar_docker
echo "✅ Docker está instalado. Versión: $(docker --version)"
