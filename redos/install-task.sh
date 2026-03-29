#!/bin/bash
#
# install-task-redos.sh
# Создание периодической задачи в cron (RedOS/Linux)
#
# Использование: sudo ./install-task-redos.sh -n "rdt-loader" -i 60 -c "date" -l "/var/log/rdt.log"
#

set -e

# Параметры по умолчанию
TASK_NAME="rdt-loader"
INTERVAL_MINUTES=60
COMMAND="date"
LOG_FILE="/var/log/rdt.log"

# Разбор аргументов
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--name)
            TASK_NAME="$2"
            shift 2
            ;;
        -i|--interval)
            INTERVAL_MINUTES="$2"
            shift 2
            ;;
        -c|--command)
            COMMAND="$2"
            shift 2
            ;;
        -l|--log)
            LOG_FILE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Использование: $0 [опции]"
            echo ""
            echo "Опции:"
            echo "  -n, --name ИМЯ         Имя задачи (без пробелов)"
            echo "  -i, --interval МИНУТЫ  Интервал в минутах"
            echo "  -c, --command КОМАНДА  Команда для выполнения"
            echo "  -l, --log ФАЙЛ         Путь к лог-файлу"
            echo "  -h, --help             Показать справку"
            echo ""
            echo "Пример:"
            echo "  sudo $0 -n rdt-loader -i 60 -c 'date' -l /var/log/rdt.log"
            exit 0
            ;;
        *)
            echo "❌ Неизвестный параметр: $1"
            exit 1
            ;;
    esac
done

# Проверка прав root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Этот скрипт нужно запускать с правами root (sudo)"
    exit 1
fi

# Создаем директорию для логов
LOG_DIR=$(dirname "$LOG_FILE")
mkdir -p "$LOG_DIR"
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

echo "✅ Создана директория: $LOG_DIR"

# Создаем уникальный идентификатор задачи
CRON_MARKER="# TASK: $TASK_NAME"

# Удаляем старую версию задачи если существует
crontab -l 2>/dev/null | grep -v "$CRON_MARKER" | crontab - 2>/dev/null || true

# Формируем cron-запись
# Интервал в минутах: */N * * * *
CRON_ENTRY="*/$INTERVAL_MINUTES * * * * $CRON_MARKER; echo \"\$(date '+%Y-%m-%d %H:%M:%S')\" >> $LOG_FILE; $COMMAND >> $LOG_FILE 2>&1; echo '---' >> $LOG_FILE"

# Добавляем в crontab
(crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -

echo "✅ Задача '$TASK_NAME' успешно создана!"
echo "   📅 Интервал: каждые $INTERVAL_MINUTES минут"
echo "   📁 Лог-файл: $LOG_FILE"
echo "   ⚙️ Команда: $COMMAND"
echo ""
echo "💡 Просмотр задач: sudo crontab -l"
echo "💡 Просмотр логов: tail -f $LOG_FILE"
