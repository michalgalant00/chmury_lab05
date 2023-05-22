# ETAP 1
# 1. ma wykorzystywać obraz bazowy „scratch” (dowolny - może być użyty w trakcie lab, obraz alpine).
# 2. ma budować prostą aplikację webową (w oparcie o Nodejs) ktora wyświetla następujące informacje:
#   - Adres IP serwera, na którym aplikacja jest uruchomiona,
#   - Nazwę serwera (hostname)
#   - Wersję aplikacji (w dowolnym schemacie)
# 3. wersja aplikacji ma być określona w poleceniu docker build(..) poprzez nadanie wartości zmiennej VERSION definiowanej przez instrukcje ARG.

FROM alpine:3.17 as builder

ARG VERSION

ENV APP_VERSION=${VERSION}

RUN apk update && \
    apk upgrade && \
    apk add --no-cache nodejs npm && \
    rm -rf /etc/apk/cache

RUN npx create-react-app my-app

WORKDIR /my-app

COPY App.js ./src

RUN npm install
RUN npm run build

# ETAP 2
# 1. ma wykorzystywać obraz bazowy Apache (w dowolnej wersji)
# 2. aplikacja z etapu pierwszego ma zostać skopiowana na serwer HTTP i ustawiona, by być domyślnie uruchamiana i wyświetlana jako strona domyślna (startowa)
# 3. ma być uwzględnione sprawdzanie poprawności działania (HEALTHCHECK)

# Stage 2 : wystawienie na apache
FROM httpd:2.4-alpine

COPY --from=build /my-app/build /usr/local/apache2/htdocs

EXPOSE 80

HEALTHCHECK --interval=10s --timeout=1s\
    CMD curl -f http://localhost:80/ || exit 1

CMD ["httpd", "-D", "FOREGROUND"]