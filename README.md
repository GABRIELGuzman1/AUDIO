PulseAudio es un servidor de sonido que funciona como una capa intermedia entre las aplicaciones de 
audio y el hardware de sonido en sistemas basados en Linux. Permite mezclar, redirigir y modificar 
audio de diferentes fuentes con flexibilidad.
Características principales:
•	Soporte para múltiples fuentes y destinos de audio.
•	Control de volumen por aplicación.
•	Redirección de audio a través de la red.
•	Soporte para Bluetooth y dispositivos externos.
•	Ecualización y efectos de audio.
Módulos de PulseAudio
Los módulos son componentes que extienden la funcionalidad de PulseAudio. Se cargan dinámicamente según
la configuración y necesidades del sistema.
Módulos comunes:
•	Load-module module-alsa-sink 
•	load-module module-native-protocol-tcp auth-ip-acl= (la ip del cliente)
•	load-module module-suspend-on-idle
HERRAMIENTAS Y UTILIDADES
PulseAudio: cuenta con varias herramientas que permiten a los usuarios administrar y configurar el 
sistema de audio de manera más detallada. Entre los más comunes en Ubuntu se encuentran Pavucontrol, 
Paprefs, y Pulseaudio-utils. A continuación, se describe cada uno de ellos.
Pavucontrol: es una interfaz gráfica que permite gestionar de manera detallada los dispositivos y 
flujos de audio en sistemas con PulseAudio. Proporciona más control que las herramientas de sonido 
predeterminadas que suelen incluir las distribuciones de Linux.
Paprefs: es otra herramienta gráfica utilizada para configurar opciones avanzadas de PulseAudio, especialmente
las relacionadas con la red y el manejo de múltiples dispositivos. Su objetivo es proporcionar un control 
más profundo sobre las preferencias del servidor PulseAudio.
Pulseaudio-utils: es un conjunto de utilidades en línea de comandos que proporcionan herramientas esenciales 
para interactuar y controlar PulseAudio. Estas herramientas son útiles para usuarios avanzados o administradores 
de sistemas que prefieren trabajar en la terminal o para automatizar ciertas tareas.

Ahora veremos la instalación breve del servicio, tanto para el servidor como para el cliente:

Este repositorio contiene la configuración necesaria para la instalación y configuración de **PulseAudio** en un servidor Linux utilizando **Ansible** y **Docker**. 
 
📂 Contenido del repositorio 

1️⃣ audio.yaml 
Este es un **Playbook de Ansible** que automatiza la instalación y configuración de **PulseAudio**. Sus principales funciones incluyen: 
 
ansible-playbook -i hosts audio.yaml 

2️⃣ Dockerfile 

Este archivo define la construcción de una imagen de Ubuntu con PulseAudio preconfigurado, permitiendo su ejecución en un entorno Docker. 

📌 Ejemplo de construcción y ejecución del contenedor: 

docker build -t pulseaudio_gabriel . 
docker run -d --name pulseaudio_gabriel -p 4713:4713 pulseaudio_gabriel 
 

🚀 Instalación Manual (Sin Ansible) 

Si no deseas utilizar Ansible, puedes instalar PulseAudio manualmente con los siguientes pasos: 

 
📌 En el Servidor 

Actualizar sistema e instalar PulseAudio: 

sudo apt update && sudo apt upgrade -y 
sudo apt install pulseaudio pavucontrol paprefs pulseaudio-utils -y 
 

Configurar TCP en default.pa: 

sudo nano /etc/pulse/default.pa 

Agregar las siguientes líneas: 

load-module module-native-protocol-tcp auth-ip-acl=[ip cliente] 

load-module module-alsa-sink 
load-module module-suspend-on-idle 

Reiniciar PulseAudio para guardar cambios: 

pulseaudio -k && pulseaudio --start 

Abrir el puerto en el firewall: 

sudo ufw enable 
sudo ufw allow 4713/tcp 

📌 En el Cliente 

Configurar variable de entorno para conectarse al servidor: 

export PULSE_SERVER=tcp:(IP_DEL_SERVIDOR) 
echo "export PULSE_SERVER=tcp:(IP_DEL_SERVIDOR)" >> ~/.bashrc 
source ~/.bashrc 

Abrir el puerto en el firewall: 

sudo ufw enable 
sudo ufw allow 4713/tcp 

 

 
 

Verificar la conexión con telnet: 

 

telnet (IP_DEL_SERVIDOR) 4713 
 

 

Prueba la reproducción de audio (descarga mpv o vlc): 

mpv --ao=pulse ejemplo.mp3 
 

En el servidor, verifica que aparece el cliente en pavucontrol. 

Esta configuración permite que el cliente se conecte al servidor PulseAudio y pueda reproducir sonido de manera remota. 

📌 En el Servidor 

Buscaremos el contenido de la ruta /usr/lib buscando la versión de pulseaudio:  

ls /usr/lib | grep pulse 

Veremos que en la versión tiene agregado +dfsg1, esto causa errores en paprefs ya que esta espera que se siga el formato estándar de versión (pulse-<versión> ). 

Para ello haremos un enlace blando con este archivo y su contenido:  

sudo ln -s /usr/lib/pulse-16.1+dfsg1/ /usr/lib/pulse-16.1 

Una vez realizada esta configuración, realizamos la detención de Pipewire (es el servicio de audio/vídeo predeterminado de Ubuntu) en el servidor que está habilitado a nivel de usuario y global en Ubuntu ya que causa conflicto con Pulseaudio al momento de recibir información del cliente. 

 

Deshabilitamos con:  

systemctl --user stop pipewire  

systemctl --user stop pipewire.socket  

systemctl -- user disable pipewire  

systemctl --user disable pipewire.socket  

Ahora a nivel global: 

sudo systemctl stop pipewire  

sudo systemctl stop pipewire.socket  

sudo systemctl disable pipewire  

sudo systemctl disable pipewire.socket 

Detenemos los servicios relacionados con PipeWire PulseAudio, que interfieren directamente con PulseAudio estándar: 

systemctl --user stop pipewirepulse.service  

systemctl --user stop pipewire-pulse.socket  

systemctl --user disable pipewire-pulse.service  

systemctl --user disable pipewire-pulse.socket  

Reiniciamos pulseaudio e iniciamos:  

pulseaudio -k y pulseaudio –start 

Finalmente Comprobamos que todo funcione correctamente, iniciamos la reproducción de un audio en el cliente: 

mpv --ao=pulse sonidito.mp3 

Utilizamos el siguiente comando para verificar si el puerto 4713 (puerto predeterminado para conexiones TCP de pulseaudio) está en uso.  

sudo netstat -tnp | grep 4713 

