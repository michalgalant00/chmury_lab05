# ETAP 1
# 1. ma wykorzystywać obraz bazowy „scratch” (dowolny - może być użyty w trakcie lab, obraz alpine).
# 2. ma budować prostą aplikację webową (w oparcie o Nodejs) ktora wyświetla następujące informacje:
#   - Adres IP serwera, na którym aplikacja jest uruchomiona,
#   - Nazwę serwera (hostname)
#   - Wersję aplikacji (w dowolnym schemacie)
# 3. wersja aplikacji ma być określona w poleceniu docker build(..) poprzez nadanie wartości zmiennej VERSION definiowanej przez instrukcje ARG.

FROM node:14-alpine as build

ARG VERSION
ENV APP_VERSION=${VERSION}

WORKDIR /my-app

COPY my-app/package* ./
COPY my-app/src ./src
COPY my-app/public ./public

RUN npm install
RUN npm run build

# ETAP 2
# 1. ma wykorzystywać obraz bazowy Apache (w dowolnej wersji)
# 2. aplikacja z etapu pierwszego ma zostać skopiowana na serwer HTTP i ustawiona, by być domyślnie uruchamiana i wyświetlana jako strona domyślna (startowa)
# 3. ma być uwzględnione sprawdzanie poprawności działania (HEALTHCHECK)

FROM nginx:1.21.1-alpine

COPY --from=build /my-app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=10s --timeout=1s \
 CMD curl -f http://localhost:80/ || exit 1

CMD ["nginx", "-g", "daemon off;"]