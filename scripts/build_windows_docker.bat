@echo off
REM Сборка Windows-dll в Windows-контейнере (scripts\Dockerfile.windows). Запускать из корня репозитория.
REM Нужен Docker Desktop в режиме Windows-контейнеров:
REM   "C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchWindowsEngine
REM (обратно для Linux-сборки: -SwitchLinuxEngine). Первая сборка образа — долго (Build Tools + vcpkg), дальше кэш.
REM Необязательно: set VCPKG_COMMIT=<sha> — те же версии зависимостей, что у Linux-сборки.
REM Результат: build\windows\SimpleKafka1C.dll
setlocal
set IMAGE=kafka_1c_windows
set CONTAINER=temp_container_windows

if not exist scripts\Dockerfile.windows (
  echo Run from repository root ^(scripts\Dockerfile.windows not found^) 1>&2
  exit /b 1
)
for /f %%o in ('docker info --format "{{.OSType}}"') do set DOCKER_OS=%%o
if /i not "%DOCKER_OS%"=="windows" (
  echo Docker is in %DOCKER_OS% containers mode. Switch: "C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchWindowsEngine 1>&2
  exit /b 1
)

docker build --isolation=hyperv -m 8g -f scripts\Dockerfile.windows --build-arg VCPKG_COMMIT=%VCPKG_COMMIT% -t %IMAGE% . || exit /b 1
docker rm -f %CONTAINER% >nul 2>&1
docker create --name %CONTAINER% %IMAGE% cmd >nul || exit /b 1
if not exist build\windows mkdir build\windows
docker cp %CONTAINER%:C:\src\build\Release\SimpleKafka1C.dll build\windows\SimpleKafka1C.dll || exit /b 1
docker rm %CONTAINER% >nul
echo Done: build\windows\SimpleKafka1C.dll
