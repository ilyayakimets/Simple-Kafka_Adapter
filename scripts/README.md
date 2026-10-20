# scripts — сборка компоненты

Все скрипты запускаются **из корня репозитория** (внутри относительные пути).
Полная инструкция со всеми граблями — [docs/building.md](../docs/building.md).

| Файл | Назначение |
|---|---|
| `build_windows.bat` | Windows: vcpkg + зависимости + гейт версии avro-cpp + Release-сборка → `build\Release\SimpleKafka1C.dll` |
| `build_windows_docker.bat` + `Dockerfile.windows` | Windows-dll в Windows-контейнере (MSVC 2022 Build Tools + vcpkg, без установки VS на машину). Docker Desktop в режиме Windows-контейнеров; `set VCPKG_COMMIT=<sha>` — те же версии зависимостей, что у Linux-образа (`docker run --rm kafka_1c_ubuntu git -C /opt/vcpkg rev-parse HEAD`) → `build\windows\SimpleKafka1C.dll` |
| `build_linux.sh` / `build_linux.bat` | Linux-бинарь через Docker (образ по `Dockerfile.ubuntu20`) → `build/linux/libSimpleKafka1C_Static.so` |
| `Dockerfile.ubuntu20` | Образ сборки на Ubuntu 20.04 (glibc >= 2.31). Гейтит avro-cpp >= 1.12.1 |
| `Dockerfile.oracle9` | Заготовка под Oracle Linux 9 / RedOS-подобные (glibc 2.34). С текущим релизом не проверялась |
| `triplets/x64-linux-static.cmake` | Overlay-триплет vcpkg с `-fPIC` — без него `.so` не линкуется |
| `avro_selftest/` | Автономные проверки Avro без 1С: декод реальных сообщений и кодирование union |

Перед пересборкой Windows «с нуля» каталог `build` удаляют — иначе кэш CMake тянет прежние настройки.
