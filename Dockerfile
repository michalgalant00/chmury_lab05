# ETAP 1
# 1. ma wykorzystywać obraz bazowy „scratch” (dowolny - może być użyty w trakcie lab, obraz alpine).
# 2. ma budować prostą aplikację webową (w oparcie o Nodejs) ktora wyświetla następujące informacje:
#   - Adres IP serwera, na którym aplikacja jest uruchomiona,
#   - Nazwę serwera (hostname)
#   - Wersję aplikacji (w dowolnym schemacie)
# 3. wersja aplikacji ma być określona w poleceniu docker build(..) poprzez nadanie wartości zmiennej VERSION definiowanej przez instrukcje ARG.

FROM node:alpine as main

ARG VERSION
ARG PORT
ENV VERSION=${VERSION}, PORT=${PORT}

WORKDIR /app

COPY ./package.json ./ && ./index.js ./

RUN npm install && npm install typescript && npm run build -- --prod --version=$VERSION
# RUN npm install

# EXPOSE ${PORT}
# CMD [ "npm", "start" ]

# ETAP 2
# 1. ma wykorzystywać obraz bazowy Nginx (w dowolnej wersji)
# 2. aplikacja z etapu pierwszego ma zostać skopiowana na serwer HTTP i ustawiona, by być domyślnie uruchamiana i wyświetlana jako strona domyślna (startowa)
# 3. ma być uwzględnione sprawdzanie poprawności działania (HEALTHCHECK)

FROM nginx:latest

COPY --from=main /app /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/default.conf

HEALTHCHECK --interval=10s --timeout=3s \
    CMD curl -f http://localhost:${PORT}/ || exit 1

EXPOSE ${PORT}

CMD [ "nginx", "-g", "daemon off;" ]