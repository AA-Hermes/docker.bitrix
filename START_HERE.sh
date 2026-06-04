#!/bin/bash
# 🧪 СИСТЕМА ЗАПУСКА ТЕСТОВ - БЫСТРЫЙ СТАРТ

cat << 'EOF'

╔══════════════════════════════════════════════════════════════════════════════╗
║                   ✅ СИСТЕМА ТЕСТИРОВАНИЯ ГОТОВА!                           ║
╚══════════════════════════════════════════════════════════════════════════════╝


🚀 БЫСТРЫЙ СТАРТ (2 команды):

   1. Откройте папку .server
   2. Запустите: bash run-tests.sh


📍 ВСЕ ФАЙЛЫ В ПАПКЕ: .server/

  ├─ run-tests.sh             ← Запуск всех тестов
  ├─ run-test-dir.sh          ← Запуск конкретной директории
  ├─ run-tests-ci.sh          ← Для CI/CD
  ├─ Makefile.tests           ← Make targets
  ├─ docker-compose-tests.yml ← Docker сервис
  │
  └─ Документация:
     ├─ INDEX.md              ← 👈 НАЧНИТЕ ОТСЮДА (навигация)
     ├─ README-TESTS.md       ← Краткое введение
     ├─ TESTS.md              ← Основные команды
     ├─ FULL_TESTS_GUIDE.md   ← Полное руководство (60+ примеров)
     ├─ CHEATSHEET.md         ← Готовые команды
     ├─ ARCHITECTURE.md       ← Архитектура системы
     ├─ INSTALL.md            ← Установка и интеграция
     └─ SUMMARY.md            ← Сводка файлов


⚡ ОСНОВНЫЕ КОМАНДЫ:

  Все тесты:
    cd .server && bash run-tests.sh

  Конкретный модуль:
    cd .server && bash run-test-dir.sh local/modules/germes.exchange

  С фильтром:
    cd .server && bash run-test-dir.sh local/tests -- --filter UserTest

  Через Makefile:
    cd .server && make -f Makefile.tests test


📊 НАЙДЕННЫЕ ТЕСТЫ:

  ✓ local/tests (6 тестов)
  ✓ local/modules/germes.exchange (1 тест)
  ✓ local/modules/germes.multibasket/tests (9 тестов)


📚 ДОКУМЕНТАЦИЯ:

  👉 Начните с: .server/INDEX.md

  Для быстрого старта (15 мин):
    1. .server/README-TESTS.md
    2. .server/TESTS.md
    3. .server/CHEATSHEET.md

  Для полного обучения (60 мин):
    → .server/FULL_TESTS_GUIDE.md


✅ ГОТОВО К ИСПОЛЬЗОВАНИЮ!

Просто выполните:
  cd .server
  bash run-tests.sh

════════════════════════════════════════════════════════════════════════════════
EOF
