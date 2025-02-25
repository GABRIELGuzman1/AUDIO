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
