# Dockerfile del repositorio base.
# Contiene cinco malas practicas deliberadas. Cada una lleva su numero en la
# linea anterior. Corregirlas es el bloque A1 de la guia del laboratorio. (CORREGIDO)

# Etapa 1: construir la aplicación
FROM public.ecr.aws/lambda/nodejs:20 AS build

# Copiar primero los archivos de dependencias
COPY package.json package-lock.json ./

# Instalar exactamente las versiones del lock file
RUN npm ci

# Copiar el código fuente
COPY src ./src

# Empaquetar la aplicación en dist/handler.js
RUN npm run build


# Etapa 2: imagen final
FROM public.ecr.aws/lambda/nodejs:20 AS final

# La imagen final recibe únicamente el artefacto empaquetado
COPY --from=build /var/task/dist/handler.js /var/task/dist/handler.js

# Lambda ejecuta la función "handler" exportada por dist/handler.js
CMD ["dist/handler.handler"]
