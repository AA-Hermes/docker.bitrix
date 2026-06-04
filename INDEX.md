# 📖 Индекс документации и файлов

## 🚀 Начните отсюда

### Я хочу...

#### ⚡ Просто запустить тесты
👉 **Выполните:**
```bash
cd .server
bash run-tests.sh
```
- Читайте: [TESTS.md](TESTS.md) (2 мин)
- Примеры: [CHEATSHEET.md](CHEATSHEET.md#самые-частые-команды)

#### 📚 Разобраться подробно
👉 **Читайте:** [FULL_TESTS_GUIDE.md](FULL_TESTS_GUIDE.md) (15 мин)
- Содержит 60+ примеров и подробные объяснения

#### 🔧 Интегрировать с моей IDE
👉 **Читайте:** [INSTALL.md](INSTALL.md#интеграция-с-ide-vs-code) (5 мин)
- Включает примеры для VS Code, VIM, Sublime и др.

#### 🤖 Интегрировать с CI/CD
👉 **Читайте:** [FULL_TESTS_GUIDE.md#cicd-интеграция](FULL_TESTS_GUIDE.md#cicd-интеграция)
- Примеры для GitHub Actions, GitLab CI, Jenkins

#### 📋 Узнать все команды
👉 **Читайте:** [CHEATSHEET.md](CHEATSHEET.md) (10 мин)
- Закомментированные готовые команды для копирования

#### 🏗️ Понять архитектуру
👉 **Читайте:** [ARCHITECTURE.md](ARCHITECTURE.md) (5 мин)
- ASCII диаграммы потока выполнения

#### 🔍 Обзор всех файлов
👉 **Читайте:** [SUMMARY.md](SUMMARY.md) (10 мин)
- Описание каждого созданного файла

---

## 📂 Структура файлов

```
.server/
├── 📄 README-TESTS.md          ← Начните тут (краткое введение)
├── 📄 TESTS.md                 ← Основная шпаргалка
├── 📖 FULL_TESTS_GUIDE.md      ← Полное руководство (основное)
├── 📋 CHEATSHEET.md            ← Готовые команды
├── 🏗️ ARCHITECTURE.md          ← Диаграммы системы
├── 🚀 INSTALL.md               ← Установка и интеграция
├── 📊 SUMMARY.md               ← Сводка всех файлов
├── 📖 INDEX.md                 ← Этот файл
│
├── 🔧 СКРИПТЫ
├── run-tests.sh                ← Запуск всех тестов
├── run-test-dir.sh             ← Запуск конкретной директории
├── run-tests-ci.sh             ← Для CI/CD
├── Makefile.tests              ← Make targets
│
├── 🐳 DOCKER
├── docker-compose-tests.yml    ← Сервис для тестов
│
└── (корневых файлов)
    └── test.sh                 ← Быстрый старт из корня
```

---

## 🎯 Основные скрипты

### `run-tests.sh` ⭐⭐⭐
Запуск всех найденных phpunit.xml
```bash
cd .server
bash run-tests.sh
```
**Документация:** [FULL_TESTS_GUIDE.md#1-run-testssh](FULL_TESTS_GUIDE.md#1-run-testssh)

### `run-test-dir.sh` ⭐⭐
Запуск тестов конкретной директории
```bash
cd .server
bash run-test-dir.sh local/modules/germes.exchange
```
**Документация:** [FULL_TESTS_GUIDE.md#2-run-test-dirsh](FULL_TESTS_GUIDE.md#2-run-test-dirsh)

### `run-tests-ci.sh` ⭐
Для CI/CD пайплайнов
```bash
cd .server
bash run-tests-ci.sh
```
**Документация:** [FULL_TESTS_GUIDE.md#3-run-tests-cish](FULL_TESTS_GUIDE.md#3-run-tests-cish)

### `test.sh` (из корня)
Быстрый ярлык
```bash
bash test.sh
```

---

## 📚 Документация по темам

### Для начинающих
1. [README-TESTS.md](README-TESTS.md) - краткое введение
2. [TESTS.md](TESTS.md) - базовые примеры
3. [CHEATSHEET.md](CHEATSHEET.md) - готовые команды

### Для разработчиков
1. [FULL_TESTS_GUIDE.md](FULL_TESTS_GUIDE.md) - полное руководство
2. [ARCHITECTURE.md](ARCHITECTURE.md) - структура системы
3. [CHEATSHEET.md](CHEATSHEET.md) - команды и параметры

### Для DevOps/CI-CD
1. [INSTALL.md](INSTALL.md#cicd-интеграция) - CI/CD примеры
2. [FULL_TESTS_GUIDE.md#cicd-интеграция](FULL_TESTS_GUIDE.md#cicd-интеграция)
3. [docker-compose-tests.yml](docker-compose-tests.yml)

### Для IDE интеграции
1. [INSTALL.md#интеграция-с-ide](INSTALL.md#интеграция-с-ide-vs-code)
2. [INSTALL.md#git-hooks](INSTALL.md#git-hooks-автоматический-запуск-перед-коммитом)

---

## 🔥 Самые полезные ссылки

| Задача | Ссылка |
|--------|--------|
| Запустить все тесты | `bash test.sh` |
| Конкретный модуль | [CHEATSHEET.md](CHEATSHEET.md#самые-частые-команды) |
| С фильтром | [FULL_TESTS_GUIDE.md#примеры](FULL_TESTS_GUIDE.md#пример-2-запуск-перед-коммитом-git-hook) |
| GitHub Actions | [FULL_TESTS_GUIDE.md#github-actions](FULL_TESTS_GUIDE.md#github-actions) |
| GitLab CI | [FULL_TESTS_GUIDE.md#gitlab-ci](FULL_TESTS_GUIDE.md#gitlab-ci) |
| Jenkins | [FULL_TESTS_GUIDE.md#jenkins](FULL_TESTS_GUIDE.md#jenkins) |
| VS Code | [INSTALL.md#интеграция-с-ide](INSTALL.md#интеграция-с-ide-vs-code) |
| Git hooks | [INSTALL.md#git-hooks](INSTALL.md#git-hooks-автоматический-запуск-перед-коммитом) |
| Проблемы | [INSTALL.md#troubleshooting](INSTALL.md#troubleshooting) |

---

## ⏱️ Время чтения

| Файл | Время | Для кого |
|------|-------|---------|
| README-TESTS.md | 2-3 мин | Все |
| TESTS.md | 5 мин | Быстро хочу начать |
| CHEATSHEET.md | 10 мин | Нужны команды |
| ARCHITECTURE.md | 5 мин | Интересна архитектура |
| SUMMARY.md | 10 мин | Обзор всех файлов |
| INSTALL.md | 15 мин | Нужна интеграция |
| FULL_TESTS_GUIDE.md | 30-45 мин | Хочу разобраться подробно |

---

## ✨ Ключевые команды

```bash
# Все тесты
bash test.sh

# Конкретный модуль
cd .server && bash run-test-dir.sh local/modules/germes.exchange

# С параметрами
cd .server && bash run-test-dir.sh local/tests -- --filter UserTest

# Через Makefile
cd .server && make -f Makefile.tests test

# Через Docker Compose
docker-compose -C .server -f docker-compose-tests.yml run --rm tests
```

---

## 🆘 Быстрая помощь

### "Как начать?"
1. Прочитайте [README-TESTS.md](README-TESTS.md) (2 мин)
2. Выполните `bash test.sh`
3. Profit! 🎉

### "Что-то не работает"
Смотрите [INSTALL.md#troubleshooting](INSTALL.md#troubleshooting)

### "Нужны примеры команд"
Смотрите [CHEATSHEET.md](CHEATSHEET.md)

### "Как интегрировать с GitHub?"
Смотрите [FULL_TESTS_GUIDE.md#github-actions](FULL_TESTS_GUIDE.md#github-actions)

### "Как в VS Code запускать?"
Смотрите [INSTALL.md#интеграция-с-ide](INSTALL.md#интеграция-с-ide-vs-code)

---

## 📞 Навигация документов

### README-TESTS.md
- ⭐ Краткое введение
- Таблица файлов
- Примеры использования
- Список найденных тестов

### TESTS.md
- ⭐ Быстрая шпаргалка
- Три способа запуска
- Параметры PHPUnit
- Структура тестов

### FULL_TESTS_GUIDE.md
- ⭐⭐⭐ **Основной документ**
- Содержание с навигацией
- Быстрый старт
- Основные скрипты
- Использование Makefile
- docker-compose подробно
- CI/CD интеграция (3 платформы)
- 20+ примеров
- Решение проблем

### CHEATSHEET.md
- ⭐ Готовые команды (готов скопировать)
- Самые частые команды
- Структура папок
- Диагностические команды
- Параметры PHPUnit

### ARCHITECTURE.md
- ⭐ Визуализация системы
- ASCII диаграммы
- Поток выполнения
- Структура файлов

### INSTALL.md
- ⭐ Инструкция по установке
- IDE интеграция
- Git hooks
- Makefile интеграция
- GitHub Actions/GitLab CI/Jenkins
- Troubleshooting

### SUMMARY.md
- ⭐ Сводка всех файлов
- Статистика
- Структура файлов
- Обнаруженные тесты

### INDEX.md (этот файл)
- 📖 Навигация между документами
- Быстрые ссылки
- По-темная организация

---

## 🎓 Путь обучения

### Путь 1: Быстрый старт (5 мин)
```
1. Прочитайте эту строку: bash test.sh
2. Готово!
```

### Путь 2: Быстрое обучение (15 мин)
```
1. README-TESTS.md (3 мин)
2. TESTS.md (5 мин)
3. CHEATSHEET.md (7 мин)
```

### Путь 3: Полное обучение (60 мин)
```
1. README-TESTS.md (3 мин)
2. TESTS.md (5 мин)
3. ARCHITECTURE.md (5 мин)
4. FULL_TESTS_GUIDE.md (30 мин)
5. INSTALL.md (15 мин)
```

### Путь 4: Для интеграции CI/CD (30 мин)
```
1. README-TESTS.md (3 мин)
2. INSTALL.md (15 мин)
3. FULL_TESTS_GUIDE.md (CI/CD раздел) (12 мин)
```

---

## 🚀 Начните немедленно

```bash
# Один шаг от тестирования:
bash test.sh

# Затем пройдите документацию с этого файла ↑
```

---

**Документация готова к использованию!** 🎉

Выберите свой путь выше и начните читать.
