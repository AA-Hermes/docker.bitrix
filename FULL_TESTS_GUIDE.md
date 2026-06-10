# 📋 Полное руководство по запуску тестов в Docker

## Содержание
1. [Быстрый старт](#быстрый-старт)
2. [Основные скрипты](#основные-скрипты)
3. [Использование Makefile](#использование-makefile)
4. [Использование docker-compose](#использование-docker-compose)
5. [CI/CD интеграция](#cicd-интеграция)
6. [Примеры](#примеры)

---

## Быстрый старт

### Минимальная установка

1. Откройте папку `.server`:
```bash
cd .server
```

2. Убедитесь, что контейнер запущен:
```bash
docker-compose up -d
```

3. Запустите все тесты:
```bash
bash run-tests.sh
```

---

## Основные скрипты

### 1. `run-tests.sh` - Запуск всех тестов

Запускает все обнаруженные phpunit.xml в папке local.

```bash
cd .server
bash run-tests.sh
```

**Особенности:**
- Автоматически находит все phpunit.xml
- Показывает цветной вывод
- Выводит итоговый отчет
- Возвращает правильный exit code

**Выход:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Запуск PHPUnit тестов в контейнере: fit24-php8.1
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Найдено тестов: 3

─────────────────────────────────────────────────────────────
Тест 1/3: local/tests
─────────────────────────────────────────────────────────────
...
```

### 2. `run-test-dir.sh` - Запуск конкретной директории

Запускает тесты в конкретной директории.

```bash
cd .server
bash run-test-dir.sh local/tests
bash run-test-dir.sh local/modules/germes.exchange
bash run-test-dir.sh local/modules/germes.multibasket/tests
```

**С дополнительными параметрами:**
```bash
# Запустить конкретный тест
bash run-test-dir.sh local/tests -- --filter TestClassName

# Запустить конкретный метод
bash run-test-dir.sh local/tests -- --filter TestClassName::testMethodName

# Verbose режим
bash run-test-dir.sh local/tests -- --verbose

# Генерировать HTML отчет
bash run-test-dir.sh local/tests -- --html=report.html
```

### 3. `run-tests-ci.sh` - Для CI/CD пайплайнов

Специализированный скрипт для автоматизированного тестирования.

```bash
cd .server

# Базовый запуск
bash run-tests-ci.sh

# С покрытием кода
COVERAGE=1 bash run-tests-ci.sh

# Verbose режим
VERBOSE=1 bash run-tests-ci.sh

# С HTML отчетом покрытия
COVERAGE=1 COVERAGE_HTML=1 bash run-tests-ci.sh
```

---

## Использование Makefile

### Вариант 1: Использовать встроенный Makefile.tests

```bash
cd .server

# Запустить все тесты
make -f Makefile.tests test

# Запустить конкретный модуль
make -f Makefile.tests test-dir DIR=local/modules/germes.exchange

# Запустить с фильтром
make -f Makefile.tests test-filter FILTER=UserTest

# Быстрые команды для популярных тестов
make -f Makefile.tests test-germes-exchange
make -f Makefile.tests test-germes-multibasket
make -f Makefile.tests test-core
```

### Вариант 2: Добавить в корневой Makefile

Если у вас есть основной Makefile в корне проекта, добавьте:

```makefile
.PHONY: test test-dir test-all

test:
	cd .server && bash run-tests.sh

test-dir:
	@test -n "$(DIR)" || (echo "Укажите DIR=<path>" && exit 1)
	cd .server && bash run-test-dir.sh $(DIR)

test-all:
	cd .server && bash run-tests.sh
```

Тогда из корня можно использовать:
```bash
make test
make test-dir DIR=local/modules/germes.exchange
```

---

## Использование docker-compose

### Способ 1: docker-compose exec (интерактивно)

```bash
# Запустить тесты в работающем контейнере
docker-compose exec -w /var/www/bitrix/local/tests php \
    php /usr/bin/phpunit --configuration phpunit.xml

# Или через контейнер базового сервиса PHP
docker-compose exec php /var/www/bitrix/.server/run-test-dir.sh local/tests
```

### Способ 2: Специализированный сервис (однократное выполнение)

Используйте `docker-compose-tests.yml` для запуска тестов как отдельного сервиса:

```bash
# Запустить тесты и завершить контейнер
docker-compose -f docker-compose.yml -f docker-compose-tests.yml \
    run --rm tests

# Или с профилем test
docker-compose --profile test up tests --abort-on-container-exit
```

---

## CI/CD интеграция

### GitHub Actions

Создайте `.github/workflows/tests.yml`:

```yaml
name: PHP Tests

on:
  push:
    branches: [ master, main, develop ]
  pull_request:
    branches: [ master, main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Start Docker Compose
        run: |
          cd .server
          docker-compose up -d
          sleep 10

      - name: Run Tests
        run: |
          cd .server
          bash run-tests-ci.sh

      - name: Stop Docker Compose
        if: always()
        run: |
          cd .server
          docker-compose down

      - name: Report Results
        if: always()
        run: |
          echo "Tests Passed: ${{ env.TESTS_PASSED }}"
          echo "Tests Failed: ${{ env.TESTS_FAILED }}"
```

### GitLab CI

Создайте `.gitlab-ci.yml`:

```yaml
test:
  image: docker:latest
  services:
    - docker:dind
  script:
    - apk add bash
    - cd .server
    - docker-compose up -d
    - sleep 10
    - bash run-tests-ci.sh
  after_script:
    - cd .server
    - docker-compose down -v
```

### Jenkins

Создайте Pipeline job:

```groovy
pipeline {
    agent any

    stages {
        stage('Setup') {
            steps {
                dir('.server') {
                    sh 'docker-compose up -d'
                    sh 'sleep 10'
                }
            }
        }

        stage('Test') {
            steps {
                dir('.server') {
                    sh 'bash run-tests-ci.sh'
                }
            }
        }
    }

    post {
        always {
            dir('.server') {
                sh 'docker-compose down -v'
            }
        }
        failure {
            echo "Tests failed!"
        }
        success {
            echo "Tests passed!"
        }
    }
}
```

---

## Примеры

### Пример 1: Полный цикл разработки

```bash
# 1. Запустить контейнер
docker-compose up -d

# 2. Запустить все тесты
bash test.sh

# 3. При падении - запустить конкретный модуль в verbose режиме
cd .server
bash run-test-dir.sh local/modules/germes.exchange -- --verbose

# 4. После исправления - снова все тесты
bash run-tests.sh
```

### Пример 2: TDD режим (постоянный прогон тестов)

```bash
# Создайте скрипт watch-tests.sh
cd .server

while true; do
    clear
    echo "Запуск тестов... $(date)"
    bash run-tests.sh
    echo ""
    echo "Ожидание изменений (Ctrl+C для выхода)..."
    sleep 5
done
```

Используйте: `bash watch-tests.sh`

### Пример 3: Отчет покрытия кода

```bash
cd .server

# Запустить с генерацией отчета покрытия
COVERAGE=1 COVERAGE_HTML=1 bash run-tests-ci.sh

# HTML отчет будет в /tmp/coverage/
# Открыть в браузере
open /tmp/coverage/local/tests/html/index.html
```

### Пример 4: Запуск перед коммитом (git hook)

Создайте `.git/hooks/pre-commit`:

```bash
#!/bin/bash

echo "Запуск тестов перед коммитом..."

cd .server
bash run-tests.sh

if [ $? -ne 0 ]; then
    echo "Тесты не пройдены! Коммит отменен."
    exit 1
fi

exit 0
```

Сделайте исполняемым: `chmod +x .git/hooks/pre-commit`

---

## Estructura файлов

```
.server/
├── docker-compose.yml          # Основная конфигурация
├── docker-compose-tests.yml    # Сервис для тестирования
├── run-tests.sh               # Запуск всех тестов
├── run-test-dir.sh            # Запуск конкретной директории
├── run-tests-ci.sh            # Для CI/CD пайплайнов
├── Makefile.tests             # Makefile targets для тестов
├── TESTS.md                   # Краткая документация (этот файл)
└── FULL_TESTS_GUIDE.md        # Полное руководство
```

---

## Решение проблем

### Проблема: "Контейнер не запущен"

**Решение:**
```bash
docker-compose up -d
sleep 5
bash test.sh
```

### Проблема: "PHPUnit не найден"

**Решение:**
```bash
# Убедитесь, что composer install выполнен
docker-compose exec php composer install

# Или установите PHPUnit вручную
docker-compose exec php composer require --dev phpunit/phpunit
```

### Проблема: "Permisison denied" при запуске скрипта

**Решение:**
```bash
chmod +x .server/run-tests.sh
chmod +x .server/run-test-dir.sh
chmod +x .server/run-tests-ci.sh
chmod +x test.sh
```

### Проблема: Разные версии PHPUnit в разных модулях

Это нормально - каждый модуль может иметь свою версию в `composer.json`. Скрипты автоматически используют локальный PHPUnit каждого модуля.

---

## Полезные команды

```bash
# Посмотреть статус контейнеров
docker-compose ps

# Посмотреть логи PHP контейнера
docker-compose logs php

# Войти в контейнер
docker-compose exec php bash

# Запустить php напрямую
docker-compose exec php php -v

# Проверить наличие phpunit
docker-compose exec php which phpunit
```

---

## Автор
Создано для проекта FIT24
