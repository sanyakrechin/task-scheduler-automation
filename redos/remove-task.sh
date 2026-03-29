#!/bin/bash
#
# remove-task-redos.sh
# Удаление задачи из cron (RedOS/Linux)
#
# Использование: sudo ./remove-task-redos.sh -n "rdt-loader"
#

set -e

TASK_NAME=""

# Разбор аргументов
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--name)
            TASK_NAME="$2"
            shift 2
            ;;
        -h|--help)
            echo "Использование: $0 -n ИМЯ_ЗАДАЧИ"
            echo ""
            echo "Пример:"
            echo "  sudo $0 -n rdt-loader"
            exit 0
            ;;
        *)
            echo "❌ Неизвестный параметр: $1"
            exit 1
            ;;
    esac
done

# Проверка параметров
if [ -z "$TASK_NAME" ]; then
    echo "❌ Укажите имя задачи: -n ИМЯ"
    exit 1
fi

# Проверка прав root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Этот скрипт нужно запускать с правами root (sudo)"
    exit 1
fi

CRON_MARKER="# TASK: $TASK_NAME"

# Проверяем существование задачи
if ! crontab -l 2>/dev/null | grep -q "$CRON_MARKER"; then
    echo "❌ Задача '$TASK_NAME' не найдена"
    exit 1
fi

# Удаляем задачу
crontab -l 2>/dev/null | grep -v "$CRON_MARKER" | crontab -

echo "✅ Задача '$TASK_NAME' успешно удалена!"
