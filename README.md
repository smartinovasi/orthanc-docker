# Setup Orthanc Docker

Repositori ini menyediakan setup Docker Compose untuk Orthanc dengan:
- PostgreSQL (database lokal di host)
- Plugin Worklists
- Orthanc Explorer 2
- OHIF viewer
- Stone Web Viewer
- Integrasi RIS
- Lua event handler

## Prasyarat
- Docker Desktop atau OrbStack sudah berjalan
- PostgreSQL lokal berjalan dan bisa diakses dari Docker

## Konfigurasi
Salin file environment contoh lalu sesuaikan nilainya.

```
cp .env.example .env
```

Edit .env:
- ORTHANC_DB_HOST (gunakan host.docker.internal di macOS)
- ORTHANC_DB_PORT
- ORTHANC_DB_NAME
- ORTHANC_DB_USER
- ORTHANC_DB_PASSWORD
- ORTHANC_RIS_HOST

## Menjalankan

```
docker compose up -d
```

## Akses
- Orthanc UI: http://localhost:8042/ui/app/
- OHIF viewer: http://localhost:8042/ohif/
- DICOM SCP: localhost:4242

## File Penting
- Docker Compose: [docker-compose.yml](docker-compose.yml)
- Lua handler: [Scripts/event-handler.lua](Scripts/event-handler.lua)
- OHIF user config: [Scripts/ohif-user-config.js](Scripts/ohif-user-config.js)

## Catatan
- Plugin OHIF Orthanc akan meng-override beberapa pengaturan OHIF (data source, router basename).
- Jika konfigurasi diubah, restart container:
  - docker compose up -d

## Log

```
docker logs orthanc-orthanc-1
```
