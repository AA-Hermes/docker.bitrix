# 🚀 Инструкция по установке системы тестирования

## Что уже сделано

✅ Все файлы уже созданы и готовы к использованию!

Созданные файлы в папке `.server/`:
- `run-tests.sh` - главный скрипт для запуска всех тестов
- `run-test-dir.sh` - запуск конкретной директории
- `run-tests-ci.sh` - для CI/CD пайплайнов
- `Makefile.tests` - make targets
- `docker-compose-tests.yml` - сервис для тестирования
- Полная документация (FULL_TESTS_GUIDE.md, TESTS.md, и др.)

В корне проекта:
- `.github/workflows/tests.yml` - GitHub Actions workflow

## ✓ Требования (которые уже должны быть)

- ✅ Docker установлен и запущен
- ✅ docker-compose установлен
- ✅ Файлы `.env` и `.env_example` настроены
- ✅ PHPUnit установлен в контейнере (через composer)

## 1️⃣ Первый запуск (проверка)

```bash
cd .server

# Убедитесь, что контейнер запущен
docker-compose up -d

# Подождите немного
sleep 5

# Проверьте статус
docker-compose ps

# Проверьте PHP
docker-compose exec php php --version
```

## 2️⃣ Запуск тестов

```bash
cd .server
bash run-tests.sh
```

## 3️⃣ Если тесты не находятся

Убедитесь, что PHPUnit установлен:

```bash
cd .server

# Вариант 1: Установить PHPUnit в контейнер
docker-compose exec php composer require --dev phpunit/phpunit

# Вариант 2: Установить для конкретного модуля
docker-compose exec php bash
cd /var/www/bitrix/local/modules/germes.exchange
composer require --dev phpunit/phpunit
```

## 4️⃣ Интеграция с IDE (VS Code)

### Добавьте Tasks

Создайте `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Run All Tests",
      "type": "shell",
      "command": "bash",
      "args": ["test.sh"],
      "presentation": {
        "reveal": "always",
        "panel": "shared"
      },
      "group": {
        "kind": "test",
        "isDefault": true
      }
    },
    {
      "label": "Run Current Directory Tests",
      "type": "shell",
      "command": "bash",
      "args": [".server/run-test-dir.sh", "${relativeFileDirname}"],
      "presentation": {
        "reveal": "always",
        "panel": "shared"
      }
    }
  ]
}
```

**Использование:**
- `Ctrl+Shift+D` → Select Task → Run All Tests
- Или `Ctrl+Shift+P` → Tasks: Run Task

### Интеграция с PHPUnit Extension

Установите расширение "PHPUnit" в VS Code и добавьте в settings.json:

```json
{
  "phpunit.phpunitPath": "/usr/bin/phpunit",
  "phpunit.execPath": "docker-compose -C .server exec -T php"
}
```

## 5️⃣ Git hooks (автоматический запуск перед коммитом)

### Создание pre-commit hook

```bash
mkdir -p .git/hooks

cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

echo "🧪 Запуск тестов перед коммитом..."
echo ""

cd "$(git rev-parse --show-toplevel)" || exit 1

if bash test.sh; then
    echo ""
    echo "✅ Тесты пройдены, коммит разрешен"
    exit 0
else
    echo ""
    echo "❌ Тесты не пройдены, коммит отменен"
    echo "Исправьте ошибки и попробуйте снова"
    exit 1
fi
EOF

chmod +x .git/hooks/pre-commit
```

**Отключить hook для конкретного коммита:**
```bash
git commit --no-verify -m "commit message"
```

## 6️⃣ Makefile интеграция

Если у вас есть основной Makefile в корне, добавьте:

```makefile
.PHONY: test test-dir test-watch

test:
	cd .server && bash run-tests.sh

test-dir:
	@test -n "$(DIR)" || (echo "Укажите DIR=path" && exit 1)
	cd .server && bash run-test-dir.sh $(DIR)

test-watch:
	@while true; do \
		clear; \
		echo "Запуск тестов..."; \
		cd .server && bash run-tests.sh || true; \
		echo "Ожидание изменений (Ctrl+C для выхода)..."; \
		sleep 5; \
	done
```

**Использование:**
```bash
make test                           # Все тесты
make test-dir DIR=local/tests      # Конкретная директория
make test-watch                    # Постоянный прогон
```

## 7️⃣ GitHub Actions (CI/CD)

Workflow уже создан в `.github/workflows/tests.yml`

**Он автоматически:**
- Запускается при push в master/main/develop
- Запускается при создании Pull Request
- Выполняет все тесты в контейнере Docker
- Показывает результаты в GitHub

Просмотр результатов:
1. Откройте ваш GitHub репозиторий
2. Перейдите на вкладку "Actions"
3. Выберите последний workflow run

## 8️⃣ Интеграция с GitLab CI

Создайте `.gitlab-ci.yml`:

```yaml
stages:
  - test

test:
  stage: test
  image: docker:latest
  services:
    - docker:dind
  variables:
    DOCKER_DRIVER: overlay2
  script:
    - apk add --no-cache bash
    - cd .server
    - docker-compose up -d
    - sleep 15
    - bash run-tests-ci.sh
  after_script:
    - cd .server
    - docker-compose down -v
  artifacts:
    when: always
    paths:
      - /tmp/coverage/
    reports:
      junit: test-results.xml
```

## 9️⃣ Интеграция с Jenkins

Создайте Pipeline job с таким содержимым:

```groovy
pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

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
            emailext(
                subject: "Tests failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: "Build failed. Check the logs: ${env.BUILD_URL}",
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
        success {
            echo "✅ All tests passed!"
        }
    }
}
```

## 🔟 Troubleshooting

### "Контейнер не запущен"
```bash
cd .server
docker-compose up -d
sleep 5
```

### "PHPUnit не найден"
```bash
docker-compose -C .server exec php which phpunit
# Если не найден - установить:
docker-compose -C .server exec php composer require --dev phpunit/phpunit
```

### "Permission denied" для скриптов
```bash
chmod +x .server/run-tests.sh
chmod +x .server/run-test-dir.sh
chmod +x .server/run-tests-ci.sh
chmod +x test.sh
```

### "Tests не находятся"
```bash
# Проверить наличие phpunit.xml
find local -name "phpunit.xml" -type f

# Проверить доступ из контейнера
docker-compose -C .server exec php ls -la /var/www/bitrix/local/tests/
```

## 📊 Проверка установки

Запустите эту команду для проверки всех компонентов:

```bash
#!/bin/bash
echo "🔍 Проверка системы тестирования..."
echo ""

echo "✓ Docker:"
docker --version

echo "✓ Docker Compose:"
docker-compose --version

echo "✓ Контейнер PHP:"
cd .server && docker-compose ps | grep php

echo "✓ PHP версия:"
docker-compose -C .server exec php php --version

echo "✓ PHPUnit:"
docker-compose -C .server exec php phpunit --version

echo "✓ Найденные phpunit.xml:"
find ../local -name "phpunit.xml" -type f | sed 's|^|  • |'

echo ""
echo "✅ Система готова к запуску тестов!"
```

## 📚 Дополнительные ресурсы

- [Полное руководство](FULL_TESTS_GUIDE.md)
- [Краткая шпаргалка](CHEATSHEET.md)
- [Архитектура системы](ARCHITECTURE.md)
- [PHPUnit документация](https://phpunit.de/documentation.html)

---

**🎉 Система готова к использованию!**

Начните с:
```bash
bash test.sh
```
