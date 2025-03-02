# Usa Ubuntu como base
FROM ubuntu:latest

# Evita preguntas en la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Instala PulseAudio y herramientas necesarias
RUN apt-get update && apt-get install -y \
    pulseaudio \
    pulseaudio-utils \
    pavucontrol \
    dbus \
    dbus-x11 \
    telnet \
    mpv && \
    rm -rf /var/lib/apt/lists/*

# Crea un usuario para ejecutar PulseAudio sin ser root
RUN useradd -m -s /bin/bash pulseaudio

# Prepara la configuración de PulseAudio
RUN mkdir -p /home/pulseaudio/.config/pulse && \
    touch /home/pulseaudio/.config/pulse/cookie && \
    chmod -R 777 /home/pulseaudio/.config/pulse && \
    chown -R pulseaudio:pulseaudio /home/pulseaudio/.config/pulse

# Usa el nuevo usuario
USER pulseaudio
WORKDIR /home/pulseaudio

# Expone el puerto 4713 para PulseAudio
EXPOSE 4713

# Comando para iniciar PulseAudio y dejarlo ejecutándose
CMD ["/bin/bash", "-c", "pulseaudio --start --disallow-exit --daemonize=no && tail -f /dev/null"]