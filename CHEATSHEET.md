#!/bin/bash
# 📋 ШПАРГАЛКА: Команды для запуска тестов

# ═══════════════════════════════════════════════════════════
# САМЫЕ ЧАСТЫЕ КОМАНДЫ
# ═══════════════════════════════════════════════════════════

# 🚀 Запустить все тесты
# cd .server && bash run-tests.sh

# 🎯 Запустить конкретный модуль
# cd .server && bash run-test-dir.sh local/modules/germes.exchange

# 📝 Запустить с фильтром
# cd .server && bash run-test-dir.sh local/tests -- --filter TestClassName

# 🔍 Запустить в verbose режиме
# cd .server && bash run-test-dir.sh local/tests -- --verbose

# ═══════════════════════════════════════════════════════════
# ЧЕРЕЗ MAKEFILE
# ═══════════════════════════════════════════════════════════

# Все тесты
# cd .server && make -f Makefile.tests test

# Конкретный модуль
# cd .server && make -f Makefile.tests test-dir DIR=local/modules/germes.exchange

# С фильтром
# cd .server && make -f Makefile.tests test-filter FILTER=UserTest

# ═══════════════════════════════════════════════════════════
# ЧЕРЕЗ DOCKER-COMPOSE
# ═══════════════════════════════════════════════════════════

# Запустить в контейнере через exec
# docker-compose -C .server exec -w /var/www/bitrix/local/tests php \
#     php /usr/bin/phpunit --configuration phpunit.xml

# Через сервис тестирования (однократное выполнение)
# docker-compose -C .server -f docker-compose-tests.yml run --rm tests

# ═══════════════════════════════════════════════════════════
# CI/CD (CONTINUOUS INTEGRATION)
# ═══════════════════════════════════════════════════════════

# Базовый CI скрипт
# cd .server && bash run-tests-ci.sh

# С покрытием кода
# cd .server && COVERAGE=1 bash run-tests-ci.sh

# Verbose режим для CI
# cd .server && VERBOSE=1 bash run-tests-ci.sh

# ═══════════════════════════════════════════════════════════
# СТРУКТУРА ПАПОК С ТЕСТАМИ
# ═══════════════════════════════════════════════════════════

# local/
#   ├── tests/
#   │   ├── phpunit.xml          ← Запуск: test.sh
#   │   ├── unit/
#   │   ├── integration/
#   │   └── functional/
#   │
#   └── modules/
#       ├── germes.exchange/
#       │   ├── phpunit.xml      ← Запуск: run-test-dir.sh local/modules/germes.exchange
#       │   └── tests/
#       │
#       └── germes.multibasket/
#           └── tests/
#               └── phpunit.xml  ← Запуск: run-test-dir.sh local/modules/germes.multibasket/tests

# ═══════════════════════════════════════════════════════════
# ПОЛЕЗНЫЕ ДИАГНОСТИЧЕСКИЕ КОМАНДЫ
# ═══════════════════════════════════════════════════════════

# Проверить статус контейнеров
# docker-compose -C .server ps

# Посмотреть логи PHP контейнера
# docker-compose -C .server logs php

# Войти в контейнер PHP
# docker-compose -C .server exec php bash

# Проверить установленный PHPUnit
# docker-compose -C .server exec php which phpunit
# docker-compose -C .server exec php phpunit --version

# Проверить версию PHP
# docker-compose -C .server exec php php --version

# ═══════════════════════════════════════════════════════════
# ПАРАМЕТРЫ PHPUNIT
# ═══════════════════════════════════════════════════════════

# --filter <pattern>      Запустить только тесты подходящие под pattern
# --verbose (-v)          Подробный вывод
# --html <file>           Генерировать HTML отчет
# --text <file>           Генерировать текстовый отчет
# --coverage-html <dir>   HTML покрытие кода
# --coverage-clover <file> Clover XML покрытие кода
# --testdox-html <file>   HTML документация тестов
# --testdox-text <file>   Текстовая документация тестов
# --colors                Цветной вывод (по умолчанию включен)
# --fail-on-risky         Ошибка если есть рискованные тесты
# --fail-on-warning       Ошибка если есть warnings
# --stop-on-failure       Остановить на первой ошибке

# ═══════════════════════════════════════════════════════════
# ПРИМЕРЫ С ПАРАМЕТРАМИ
# ═══════════════════════════════════════════════════════════

# Запустить один конкретный тест
# cd .server && bash run-test-dir.sh local/tests -- \
#     --filter "Tests\\Unit\\UserTest::testCreate"

# Запустить все тесты класса
# cd .server && bash run-test-dir.sh local/tests -- \
#     --filter "Tests\\Unit\\UserTest"

# Генерировать отчет с покрытием кода
# cd .server && bash run-test-dir.sh local/tests -- \
#     --coverage-html=coverage-report

# Запустить и остановить на первой ошибке
# cd .server && bash run-test-dir.sh local/tests -- \
#     --stop-on-failure --verbose

# ═══════════════════════════════════════════════════════════
# ИНТЕГРАЦИЯ С GIT HOOKS (PRE-COMMIT)
# ═══════════════════════════════════════════════════════════

# Создать pre-commit hook:
# cat > .git/hooks/pre-commit << 'EOF'
# #!/bin/bash
# cd "$(git rev-parse --show-toplevel)" || exit 1
# echo "Запуск тестов перед коммитом..."
# bash test.sh || exit 1
# exit 0
# EOF
#
# chmod +x .git/hooks/pre-commit

# ═══════════════════════════════════════════════════════════
# ИНТЕГРАЦИЯ С VS CODE
# ═══════════════════════════════════════════════════════════

# Добавьте в .vscode/tasks.json для запуска тестов из VS Code:
# {
#   "version": "2.0.0",
#   "tasks": [
#     {
#       "label": "Run All Tests",
#       "type": "shell",
#       "command": "bash",
#       "args": ["test.sh"],
#       "group": {
#         "kind": "test",
#         "isDefault": true
#       },
#       "problemMatcher": {
#         "pattern": {
#           "regexp": "^.*?Error.*?$",
#           "message": 1
#         }
#       }
#     }
#   ]
# }

# Затем используйте Ctrl+Shift+D (Tasks) или командой:
# Ctrl+Shift+P > Tasks: Run Test Task

# ═══════════════════════════════════════════════════════════
# ТРУБУЕМЫЕ МИНИМАЛЬНЫЕ ВЕРСИИ
# ═══════════════════════════════════════════════════════════

# Docker: 20.10+
# Docker Compose: 1.29+
# PHP: 7.4+
# PHPUnit: 7.0+ (зависит от проекта)

# ═══════════════════════════════════════════════════════════
# ДОКУМЕНТАЦИЯ
# ═══════════════════════════════════════════════════════════

# Краткое руководство: TESTS.md
# Полное руководство: FULL_TESTS_GUIDE.md
# README: README-TESTS.md

echo "📚 Документация: .server/FULL_TESTS_GUIDE.md"
echo "⚡ Быстрый старт: bash test.sh"
