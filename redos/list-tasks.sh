#!/bin/bash
#
# list-tasks-redos.sh
# Просмотр списка задач cron (RedOS/Linux)
#
# Использование: ./list-tasks-redos.sh [поиск]
#

SEARCH_PATTERN="${1:-}"

echo ""
echo "📋 Список периодических задач (cron)"
echo "============================================================"
echo ""

# Получаем текущий crontab
CRON_CONTENT=$(crontab -l 2>/dev/null || echo "")

if [ -z "$CRON_CONTENT" ]; then
    echo "❌ Нет активных задач"
    exit 0
fi

# Фильтруем по шаблону если указан
if [ -n "$SEARCH_PATTERN" ]; then
    FILTERED=$(echo "$CRON_CONTENT" | grep -i "$SEARCH_PATTERN" || echo "")
    if [ -z "$FILTERED" ]; then
        echo "❌ Задачи по шаблону '$SEARCH_PATTERN' не найдены"
        exit 0
    fi
    CRON_CONTENT="$FILTERED"
fi

# Парсим и выводим задачи
FOUND_TASKS=0
while IFS= read -r line; do
    # Пропускаем пустые строки и комментарии (кроме маркеров # TASK:)
    if [ -z "$line" ]; then continue; fi
    if [[ "$line" =~ ^# ]] && [[ ! "$line" =~ ^#\ TASK: ]]; then continue; fi
    
    # Извлекаем имя задачи из маркера
    if [[ "$line" =~ #\ TASK:\ (.+) ]]; then
        TASK_NAME="${BASH_REMATCH[1]}"
        FOUND_TASKS=$((FOUND_TASKS + 1))
        
        # Извлекаем расписание (первые 5 полей)
        SCHEDULE=$(echo "$line" | awk '{print $1" "$2" "$3" "$4" "$5}')
        
        echo "📌 $TASK_NAME"
        
        # Парсим расписание
        if [[ "$SCHEDULE" =~ \*/([0-9]+) ]]; then
            INTERVAL="${BASH_REMATCH[1]}"
            echo "   📅 Интервал: каждые $INTERVAL минут"
        fi
        
        # Извлекаем команду
        COMMAND=$(echo "$line" | sed 's/.*# TASK: [^;]*; //')
        echo "   ⚙️ Команда: $COMMAND"
        echo ""
    fi
done <<< "$CRON_CONTENT"

if [ $FOUND_TASKS -eq 0 ]; then
    echo "❌ Пользовательских задач не найдено"
    echo ""
    echo "💡 Для просмотра всех cron-записей: sudo crontab -l"
else
    echo "📝 Всего задач: $FOUND_TASKS"
fi

echo ""
echo "💡 Управление задачами:"
echo "   Создать: sudo ./install-task.sh -n ИМЯ -i МИНУТЫ -c КОМАНДА"
echo "   Удалить: sudo ./remove-task.sh -n ИМЯ"
