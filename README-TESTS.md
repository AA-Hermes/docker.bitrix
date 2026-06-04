# 🧪 Система запуска тестов в Docker

Полная система для запуска PHPUnit тестов в Docker контейнере PHP.

## ⚡ Быстрый старт

```bash
cd .server
bash run-tests.sh
```

## 📦 Что включено

| Файл | Назначение |
|------|-----------|
| `run-tests.sh` | Запуск всех phpunit.xml из папки local |
| `run-test-dir.sh` | Запуск тестов конкретной директории |
| `run-tests-ci.sh` | Для CI/CD пайплайнов с доп. опциями |
| `test.sh` | Удобный ярлык из корня проекта |
| `Makefile.tests` | Make targets для тестов |
| `docker-compose-tests.yml` | Сервис для однократного запуска |

## 🎯 Примеры использования

```bash
# Запустить все тесты
bash test.sh

# Запустить конкретный модуль
cd .server && bash run-test-dir.sh local/modules/germes.exchange

# С фильтром
cd .server && bash run-test-dir.sh local/tests -- --filter UserTest

# Через Makefile
make -f .server/Makefile.tests test-germes-exchange

# Через docker-compose
docker-compose -f .server/docker-compose.yml \
    -f .server/docker-compose-tests.yml run --rm tests
```

## 📍 Найденные тесты

Автоматически обнаружены:
- ✓ `local/tests/phpunit.xml`
- ✓ `local/modules/germes.exchange/phpunit.xml`
- ✓ `local/modules/germes.multibasket/tests/phpunit.xml`

## 📚 Документация

- **[TESTS.md](TESTS.md)** - Краткая шпаргалка
- **[FULL_TESTS_GUIDE.md](FULL_TESTS_GUIDE.md)** - Полное руководство (60+ примеров)

## 🛠️ Требования

- Docker и docker-compose запущены
- `.env` файл настроен
- PHPUnit установлен в контейнере (через composer)

## 💡 Совет

Скрипты автоматически находят все `phpunit.xml` в папке `local`, поэтому:
- Добавляйте новые тесты просто создав `phpunit.xml` в нужной директории
- Скрипты будут их автоматически обнаруживать

## 🔧 CI/CD

Готовые примеры для:
- GitHub Actions
- GitLab CI
- Jenkins

Смотрите полное руководство: [FULL_TESTS_GUIDE.md](FULL_TESTS_GUIDE.md#cicd-интеграция)
