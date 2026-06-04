# Запуск тестов в Docker

## Быстрый старт

### 1. Запуск всех тестов

```bash
cd .server
bash run-tests.sh
```

### 2. Запуск тестов конкретной директории

Из папки `.server`:
```bash
bash run-test-dir.sh local/tests
bash run-test-dir.sh local/modules/germes.exchange
bash run-test-dir.sh local/modules/germes.multibasket/tests
```

### 3. Запуск с дополнительными параметрами

```bash
# Запустить только один тест
bash run-test-dir.sh local/tests -- --filter TestClassName

# Запустить с опцией verbose
bash run-test-dir.sh local/tests -- --verbose

# Запустить и сгенерировать HTML отчет
bash run-test-dir.sh local/tests -- --html report.html
```

## Через docker-compose exec (альтернатива)

```bash
# Запуск PHPUnit напрямую в контейнере
docker-compose exec -w /var/www/bitrix/local/tests php \
    php /usr/bin/phpunit --configuration phpunit.xml

# Или через Makefile
make test
make test-dir DIR=local/modules/germes.exchange
```

## Структура

- `run-tests.sh` - главный скрипт, запускает все phpunit.xml в папке local
- `run-test-dir.sh` - запускает тесты конкретной директории
- `../test.sh` - удобный способ запуска из корня проекта
- `Makefile` - targets для часто используемых команд

## Требования

- Docker контейнер должен быть запущен: `docker-compose up -d`
- PHPUnit должен быть установлен в контейнере через composer
- Файлы `.env` и `.env_example` должны быть настроены

## Найденные тесты

Скрипты автоматически обнаруживают следующие phpunit.xml:
- `local/tests/phpunit.xml`
- `local/modules/germes.exchange/phpunit.xml`
- `local/modules/germes.multibasket/tests/phpunit.xml`

При добавлении новых тестов просто добавьте `phpunit.xml` в нужную директорию и скрипты найдут их автоматически.
