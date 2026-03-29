# Task Scheduler Automation Scripts

Автоматизация управления периодическими задачами для Windows (Task Scheduler) и RedOS/Linux (cron).

## 📁 Структура проекта

```
task-scheduler-scripts/
├── windows/              # PowerShell скрипты для Windows
│   ├── install-task.ps1  # Создание задачи
│   ├── remove-task.ps1   # Удаление задачи
│   └── list-tasks.ps1    # Список задач
├── redos/                # Bash скрипты для RedOS/Linux
│   ├── install-task.sh   # Создание задачи
│   ├── remove-task.sh    # Удаление задачи
│   └── list-tasks.sh     # Список задач
└── README.md
```

## 🪟 Windows (Task Scheduler)

### Требования
- Windows 7/8/10/11 или Windows Server
- PowerShell 3.0+
- Права администратора (Run as Administrator)

### Установка задачи

```powershell
# Создать задачу, выполняющуюся каждые 60 минут
.\install-task.ps1 -TaskName "RdtLoader" -IntervalMinutes 60 -Command "date" -LogFile "C:\Logs\rdt.log"
```

**Параметры:**
- `-TaskName` — уникальное имя задачи
- `-IntervalMinutes` — интервал в минутах
- `-Command` — команда для выполнения
- `-LogFile` — путь к файлу логов (опционально)

### Удаление задачи

```powershell
.\remove-task.ps1 -TaskName "RdtLoader"
```

### Просмотр задач

```powershell
# Все задачи
.\list-tasks.ps1

# Поиск по имени
.\list-tasks.ps1 -TaskName "Rdt"
```

## 🐧 RedOS / Linux (cron)

### Требования
- RedOS 7.3+ / CentOS 7+ / RHEL 7+ / любой Linux с cron
- Bash
- Права root (sudo)

### Установка задачи

```bash
# Создать задачу, выполняющуюся каждые 60 минут
sudo ./install-task.sh -n "rdt-loader" -i 60 -c "date" -l "/var/log/rdt.log"
```

**Параметры:**
- `-n, --name` — уникальное имя задачи
- `-i, --interval` — интервал в минутах
- `-c, --command` — команда для выполнения
- `-l, --log` — путь к файлу логов (опционально)

### Удаление задачи

```bash
sudo ./remove-task.sh -n "rdt-loader"
```

### Просмотр задач

```bash
# Все задачи
./list-tasks.sh

# Поиск по имени
./list-tasks.sh rdt
```

## 🧪 Тестовая команда

Для тестирования используйте простую команду записи даты/времени в лог:

**Windows:**
```powershell
.\install-task.ps1 -TaskName "TestTask" -IntervalMinutes 5 -Command "Get-Date"
```

**RedOS:**
```bash
sudo ./install-task.sh -n "test-task" -i 5 -c "date" -l "/tmp/test.log"
```

Проверка работы:
- Windows: `Get-Content C:\Logs\task.log -Wait`
- RedOS: `tail -f /tmp/test.log`

## 🔧 Интеграция с RDT-загрузчиком

Когда будет готов загрузчик RDT, замените тестовую команду:

**Windows:**
```powershell
.\install-task.ps1 -TaskName "RdtLoader" -IntervalMinutes 60 -Command "C:\RdtLoader\load-rdt.exe" -LogFile "C:\RdtLoader\logs\scheduler.log"
```

**RedOS:**
```bash
sudo ./install-task.sh -n "rdt-loader" -i 60 -c "/opt/rdt-loader/load-rdt.sh" -l "/var/log/rdt/scheduler.log"
```

## 📋 Примеры использования

### Ежечасная проверка новых файлов

**Windows:**
```powershell
.\install-task.ps1 -TaskName "CheckFiles" -IntervalMinutes 60 -Command "dir C:\Incoming\*.rdt"
```

**RedOS:**
```bash
sudo ./install-task.sh -n "check-files" -i 60 -c "ls -la /opt/incoming/*.rdt 2>/dev/null || echo 'No files'"
```

### Ежедневная загрузка в 9:00

**Windows:**
```powershell
# Интервал 1440 минут = 24 часа
.\install-task.ps1 -TaskName "DailyLoad" -IntervalMinutes 1440 -Command "C:\loader.exe"
```

**RedOS:**
```bash
# Интервал 1440 минут = 24 часа
sudo ./install-task.sh -n "daily-load" -i 1440 -c "/opt/loader.sh"
```

## 🛠️ Отладка

### Windows

```powershell
# Просмотр всех задач
Get-ScheduledTask

# Просмотр истории выполнения
Get-ScheduledTaskInfo "RdtLoader"

# Ручной запуск задачи
Start-ScheduledTask -TaskName "RdtLoader"

# Просмотр логов Windows
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-TaskScheduler/Operational'} | Select-Object -First 10
```

### RedOS

```bash
# Просмотр текущих cron-задач
sudo crontab -l

# Просмотр системных логов cron
sudo grep CRON /var/log/cron

# Проверка статуса cron
crontab -l | head -5

# Ручная проверка команды
bash -x /path/to/command.sh
```

## 📄 Лицензия

MIT License — свободное использование в коммерческих и некоммерческих проектах.

## 👤 Автор

Created for personal workflow automation.
