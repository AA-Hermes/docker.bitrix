#!/bin/bash

# Скрипт для запуска конкретного набора тестов
# Использование: ./run-test-dir.sh local/modules/germes.exchange

set -e

TEST_DIR="${1:-.}"
PROJECT_NAME=$(grep ^PROJECT_NAME .env | cut -d '=' -f2 | xargs)
PHP_VERSION=$(grep ^PHP_VERSION .env | cut -d '=' -f2 | xargs)
CONTAINER_NAME="${PROJECT_NAME}-php${PHP_VERSION}"

# Нормализуем путь (удаляем ../ в начале если есть)
TEST_DIR=$(echo "$TEST_DIR" | sed 's|^\.\./||')

# Проверяем, что директория существует и содержит phpunit.xml
if [ ! -f "../local/$TEST_DIR/phpunit.xml" ]; then
    echo "Ошибка: phpunit.xml не найден в ../local/$TEST_DIR/"
    echo ""
    echo "Доступные тесты:"
    find ../local -name "phpunit.xml" -type f -not -path "*/vendor/*" | sed 's|^\.\.||' | sed 's|/phpunit.xml||'
    exit 1
fi

echo "Запуск тестов в: /var/www/bitrix/local/$TEST_DIR"
echo ""

docker exec -w "/var/www/bitrix/local/$TEST_DIR" "$CONTAINER_NAME" \
    php ./vendor/bin/phpunit --configuration phpunit.xml --colors=always "$@"
