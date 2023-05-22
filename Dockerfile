#
# Michał Galant
#

# ETAP 1 : budowanie

# wykorzystanie obrazu node w wersji 14-alpine jako bazowego - do budowania
FROM node:14-alpine as builder

# parametr VERSION do przekazania wersji obrazu
ARG APP_VERSION
# wprowadzenie zmiennej środowiskowej i przypisanie do niej wartości VERSION
ENV APP_VERSION=${APP_VERSION}

# ustawienie katalogu roboczego
WORKDIR /my-app

# skopiowanie całej aplikacji
COPY my-app/package* ./
COPY my-app/src ./src
COPY my-app/public ./public

# instalacja zależności
RUN npm install
# zbudowanie aplikacji
RUN npm run build

# ETAP 2 : wystawienie aplikacji

# wykorzystanie obrazu apache
FROM httpd:2.4-alpine

# przekazanie parametru i zmiennej środowiskowej do serwera
ARG APP_VERSION
ENV APP_VERSION=${APP_VERSION}

# skopiowanie zbudowanej aplikacji do serwera
COPY --from=builder /my-app/build /usr/local/apache2/htdocs

# wystawienie aplikacji na port 80
EXPOSE 80

# monitorowanie stanu aplikacji na serwerze
HEALTHCHECK --interval=10s --timeout=1s\
    CMD curl -f http://localhost:80/ || exit 1

# uruchomienie serwera
CMD ["httpd", "-D", "FOREGROUND"]