#!/bin/bash

# Скрипт для запуска всех PHPUnit тестов в Docker контейнере
# Находит все phpunit.xml в папке local и запускает тесты для каждого

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Получаем имя проекта из .env
PROJECT_NAME=$(grep ^PROJECT_NAME .env | cut -d '=' -f2 | xargs)
PHP_VERSION=$(grep ^PHP_VERSION .env | cut -d '=' -f2 | xargs)
CONTAINER_NAME="${PROJECT_NAME}-php${PHP_VERSION}"

# Переменные для отслеживания результатов
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
FAILED_DIRS=()

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Запуск PHPUnit тестов в контейнере: ${CONTAINER_NAME}${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Проверяем, работает ли контейнер
if ! docker ps | grep -q "$CONTAINER_NAME"; then
    echo -e "${RED}✗ Контейнер $CONTAINER_NAME не запущен${NC}"
    echo "Используйте: docker-compose up -d"
    exit 1
fi

# Находим все phpunit.xml файлы (исключаем vendor папки)
PHPUNIT_FILES=$(find ../local -name "phpunit.xml" -type f -not -path "*/vendor/*")

if [ -z "$PHPUNIT_FILES" ]; then
    echo -e "${RED}✗ Файлы phpunit.xml не найдены в папке local${NC}"
    exit 1
fi

# Подсчитываем количество файлов
FILE_COUNT=$(echo "$PHPUNIT_FILES" | wc -l)
echo -e "${YELLOW}Найдено тестов: ${FILE_COUNT}${NC}"
echo ""

# Запускаем тесты для каждого phpunit.xml
for phpunit_file in $PHPUNIT_FILES; do
    # Получаем директорию с phpunit.xml
    test_dir=$(dirname "$phpunit_file")
    test_dir_relative=$(echo "$test_dir" | sed 's|^\.\./||')
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    echo -e "${BLUE}─────────────────────────────────────────────────────────────${NC}"
    echo -e "${BLUE}Тест ${TOTAL_TESTS}/${FILE_COUNT}: ${test_dir_relative}${NC}"
    echo -e "${BLUE}─────────────────────────────────────────────────────────────${NC}"
    
    # Запускаем тесты внутри контейнера
    if docker exec -w "/var/www/bitrix/$test_dir_relative" "$CONTAINER_NAME" \
        php ./vendor/bin/phpunit --configuration phpunit.xml --colors=always; then
        
        echo -e "${GREEN}✓ Успешно: ${test_dir_relative}${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}✗ Ошибка: ${test_dir_relative}${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        FAILED_DIRS+=("$test_dir_relative")
    fi
    
    echo ""
done

# Итоговый отчет
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}ИТОГОВЫЙ ОТЧЕТ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Всего тестов: ${TOTAL_TESTS}"
echo -e "${GREEN}Успешно: ${PASSED_TESTS}${NC}"
echo -e "${RED}Ошибок: ${FAILED_TESTS}${NC}"

if [ $FAILED_TESTS -gt 0 ]; then
    echo ""
    echo -e "${RED}Директории с ошибками:${NC}"
    for dir in "${FAILED_DIRS[@]}"; do
        echo -e "  ${RED}✗ $dir${NC}"
    done
    echo ""
    exit 1
else
    echo -e "${GREEN}✓ Все тесты пройдены успешно!${NC}"
    echo ""
    exit 0
fi
