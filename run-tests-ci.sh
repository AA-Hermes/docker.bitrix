#!/bin/bash

# Скрипт для интеграции тестов в CI/CD пайплайны
# Подходит для GitHub Actions, GitLab CI, Jenkins и т.д.

set -e

PROJECT_NAME=$(grep ^PROJECT_NAME .env | cut -d '=' -f2 | xargs)
PHP_VERSION=$(grep ^PHP_VERSION .env | cut -d '=' -f2 | xargs)
CONTAINER_NAME="${PROJECT_NAME}-php${PHP_VERSION}"

# Опции
VERBOSE=${VERBOSE:-0}
COVERAGE=${COVERAGE:-0}
COVERAGE_HTML=${COVERAGE_HTML:-}

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Проверяем, работает ли контейнер
if ! docker ps | grep -q "$CONTAINER_NAME"; then
    error "Контейнер $CONTAINER_NAME не запущен"
    exit 1
fi

log "Начинаю запуск тестов в контейнере: $CONTAINER_NAME"

# Находим все phpunit.xml файлы
PHPUNIT_FILES=$(find ../local -name "phpunit.xml" -type f)

if [ -z "$PHPUNIT_FILES" ]; then
    error "Файлы phpunit.xml не найдены в папке local"
    exit 1
fi

TOTAL=0
PASSED=0
FAILED=0
FAILED_DIRS=()

# Запускаем тесты для каждого phpunit.xml
for phpunit_file in $PHPUNIT_FILES; do
    test_dir=$(dirname "$phpunit_file")
    test_dir_relative=$(echo "$test_dir" | sed 's|^\.\./||')

    TOTAL=$((TOTAL + 1))

    log "Запуск тестов для: $test_dir_relative ($TOTAL)"

    # Подготавливаем команду phpunit
    PHPUNIT_CMD="php ./vendor/bin/phpunit --configuration phpunit.xml"

    # Добавляем опции для покрытия кода если указано
    if [ "$COVERAGE" = "1" ]; then
        COVERAGE_DIR="/tmp/coverage/$test_dir_relative"
        PHPUNIT_CMD="$PHPUNIT_CMD --coverage-clover=$COVERAGE_DIR/clover.xml"
        PHPUNIT_CMD="$PHPUNIT_CMD --coverage-text=$COVERAGE_DIR/coverage.txt"

        if [ ! -z "$COVERAGE_HTML" ]; then
            PHPUNIT_CMD="$PHPUNIT_CMD --coverage-html=$COVERAGE_DIR/html"
        fi
    fi

    # Добавляем флаг verbose
    if [ "$VERBOSE" = "1" ]; then
        PHPUNIT_CMD="$PHPUNIT_CMD --verbose"
    fi

    # Запускаем тесты
    if docker exec -w "/var/www/bitrix/$test_dir_relative" "$CONTAINER_NAME" \
        bash -c "$PHPUNIT_CMD"; then

        success "$test_dir_relative"
        PASSED=$((PASSED + 1))
    else
        error "$test_dir_relative"
        FAILED=$((FAILED + 1))
        FAILED_DIRS+=("$test_dir_relative")
    fi
done

# Вывод результатов
echo ""
log "═══════════════════════════════════════════════════════════════"
log "Результаты тестирования"
log "═══════════════════════════════════════════════════════════════"
log "Всего тестов: $TOTAL"
success "Успешно: $PASSED"
if [ $FAILED -gt 0 ]; then
    error "Ошибок: $FAILED"
fi

if [ $FAILED -gt 0 ]; then
    echo ""
    warn "Директории с ошибками:"
    for dir in "${FAILED_DIRS[@]}"; do
        echo "  - $dir"
    done

    # Экспортируем переменные для использования в CI
    echo "TESTS_PASSED=$PASSED" >> "$GITHUB_ENV" 2>/dev/null || true
    echo "TESTS_FAILED=$FAILED" >> "$GITHUB_ENV" 2>/dev/null || true

    exit 1
else
    success "Все тесты пройдены успешно!"

    # Экспортируем переменные для использования в CI
    echo "TESTS_PASSED=$PASSED" >> "$GITHUB_ENV" 2>/dev/null || true
    echo "TESTS_FAILED=0" >> "$GITHUB_ENV" 2>/dev/null || true

    exit 0
fi
