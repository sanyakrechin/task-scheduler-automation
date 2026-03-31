# Task Scheduler Automation

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://docs.microsoft.com/powershell/)
[![Bash](https://img.shields.io/badge/Bash-4.0+-green.svg)](https://www.gnu.org/software/bash/)

> Кросс-платформенная автоматизация управления периодическими задачами для Windows (Task Scheduler) и RedOS/Linux (cron).

## 📋 Описание

Этот репозиторий содержит скрипты для программного управления периодическими задачами без использования GUI. Решение позволяет автоматизировать создание, удаление и мониторинг задач как на Windows, так и на Linux-системах (включая отечественную RedOS).

**Основное применение**: Автоматизация загрузки данных, регулярные бэкапы, периодическая обработка файлов (например, .rdt файлов).

## 🏗️ Архитектура

```
┌─────────────────────────────────────────────┐
│          Task Scheduler Automation          │
├──────────────────┬──────────────────────────┤
│     Windows      │      RedOS/Linux         │
│  Task Scheduler  │         cron             │
├──────────────────┼──────────────────────────┤
│  install-task.ps1│    install-task.sh       │
│  remove-task.ps1 │    remove-task.sh        │
│  list-tasks.ps1  │    list-tasks.sh         │
└──────────────────┴──────────────────────────┘
```

## 📁 Структура репозитория

```
task-scheduler-scripts/
├── windows/              # PowerShell скрипты (Windows)
│   ├── install-task.ps1  # Создание задачи
│   ├── remove-task.ps1   # Удаление задачи
│   └── list-tasks.ps1    # Список задач
├── redos/                # Bash скрипты (RedOS/CentOS/RHEL)
│   ├── install-task.sh   # Создание задачи
│   ├── remove-task.sh    # Удаление задачи
│   └── list-tasks.sh     # Список задач
├── LICENSE               # MIT License
└── README.md             # Документация (этот файл)
```

## 🚀 Быстрый старт

### Windows (PowerShell)

**Требования:**
- Windows 7/8/10/11 или Windows Server 2012+
- PowerShell 5.1 или выше
- Права администратора

**Установка задачи (каждые 60 минут):**

```powershell
# Открой PowerShell от имени Администратора
cd windows
.\install-task.ps1 -TaskName "DataLoader" -IntervalMinutes 60 -Command "python C:\Scripts\load_data.py" -LogFile "C:\Logs\task.log"
```

**Результат:**
- ✅ Создана задача "DataLoader"
- ✅ Интервал: каждые 60 минут
- ✅ Логирование в C:\Logs\task.log
- ✅ Автоматический запуск

**Просмотр задач:**
```powershell
.\list-tasks.ps1
```

**Удаление задачи:**
```powershell
.\remove-task.ps1 -TaskName "DataLoader"
```

### RedOS / Linux (Bash)

**Требования:**
- RedOS 7.3+, CentOS 7+, RHEL 7+, Ubuntu 18.04+
- Bash 4.0+
- cron (установлен по умолчанию)
- Права root (sudo)

**Установка задачи:**

```bash
# Перейди в папку
chmod +x redos/*.sh
cd redos

# Установить задачу (каждые 60 минут)
sudo ./install-task.sh -n "data-loader" -i 60 -c "python3 /opt/scripts/load_data.py" -l "/var/log/task.log"
```

**Просмотр задач:**
```bash
./list-tasks.sh
```

**Удаление задачи:**
```bash
sudo ./remove-task.sh -n "data-loader"
```

## 📖 Детальная документация

### Windows PowerShell

#### install-task.ps1

Создает новую задачу в Task Scheduler.

**Параметры:**
- `-TaskName` (обязательный) — уникальное имя задачи
- `-IntervalMinutes` (обязательный) — интервал выполнения в минутах
- `-Command` (обязательный) — команда или скрипт для выполнения
- `-LogFile` (опциональный) — путь к файлу логов (по умолчанию: C:\Logs\task.log)

**Примеры:**

```powershell
# Простая команда каждые 5 минут
.\install-task.ps1 -TaskName "Test" -IntervalMinutes 5 -Command "Get-Date"

# Python-скрипт с кастомным логом
.\install-task.ps1 -TaskName "RdtLoader" -IntervalMinutes 60 -Command "python C:\Scripts\loader.py" -LogFile "C:\Rdt\logs\scheduler.log"

# Ежедневная задача (1440 минут = 24 часа)
.\install-task.ps1 -TaskName "DailyBackup" -IntervalMinutes 1440 -Command "C:\Backup\backup.bat"
```

#### remove-task.ps1

Удаляет задачу по имени.

```powershell
.\remove-task.ps1 -TaskName "RdtLoader"
```

#### list-tasks.ps1

Показывает список задач со статусами и временем следующего запуска.

```powershell
# Все задачи
.\list-tasks.ps1

# Поиск по имени
.\list-tasks.ps1 -TaskName "Rdt"
```

### RedOS / Linux Bash

#### install-task.sh

**Параметры:**
- `-n, --name` — имя задачи (без пробелов)
- `-i, --interval` — интервал в минутах
- `-c, --command` — команда для выполнения
- `-l, --log` — путь к лог-файлу
- `-h, --help` — справка

**Примеры:**

```bash
# Простая тестовая задача (каждые 5 минут)
sudo ./install-task.sh -n "test" -i 5 -c "date" -l "/tmp/test.log"

# Загрузка данных с Python
sudo ./install-task.sh -n "rdt-loader" -i 60 -c "python3 /opt/rdt-loader/load.py" -l "/var/log/rdt.log"

# Бэкап каждые 24 часа
sudo ./install-task.sh -n "backup" -i 1440 -c "/opt/backup/backup.sh" -l "/var/log/backup.log"
```

#### remove-task.sh

```bash
sudo ./remove-task.sh -n "rdt-loader"
```

#### list-tasks.sh

```bash
# Все задачи
./list-tasks.sh

# Поиск
./list-tasks.sh rdt
```

## 🧪 Тестирование

### Тестовый сценарий

**Windows:**
```powershell
cd windows
.\install-task.ps1 -TaskName "TestDemo" -IntervalMinutes 5 -Command "Get-Date" -LogFile "C:\Logs\demo.log"
Start-Sleep -Seconds 5
.\list-tasks.ps1 -TaskName "TestDemo"
# Ждем 5 минут и проверяем лог
Get-Content C:\Logs\demo.log -Tail 5
.\remove-task.ps1 -TaskName "TestDemo"
```

**RedOS:**
```bash
cd redos
sudo ./install-task.sh -n "demo" -i 5 -c "date" -l "/tmp/demo.log"
./list-tasks.sh demo
# Ждем 5 минут
sudo tail -f /tmp/demo.log
sudo ./remove-task.sh -n "demo"
```

## 🔧 Интеграция с RDT-загрузчиком

Когда будет готов загрузчик .rdt файлов, замените тестовую команду:

**Windows:**
```powershell
.\install-task.ps1 -TaskName "RdtLoader" -IntervalMinutes 60 -Command "C:\RdtLoader\load-rdt.exe" -LogFile "C:\RdtLoader\logs\scheduler.log"
```

**RedOS:**
```bash
sudo ./install-task.sh -n "rdt-loader" -i 60 -c "/opt/rdt-loader/load-rdt.sh" -l "/var/log/rdt/scheduler.log"
```

## 🐛 Отладка

### Windows

```powershell
# Просмотр всех задач
Get-ScheduledTask | Where-Object {$_.TaskName -like "*Rdt*"}

# Просмотр истории
Get-ScheduledTaskInfo -TaskName "RdtLoader"

# Ручной запуск
Start-ScheduledTask -TaskName "RdtLoader"

# Просмотр логов Windows
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-TaskScheduler/Operational'} | Select-Object -First 10
```

### RedOS / Linux

```bash
# Просмотр cron-задач
sudo crontab -l | grep "TASK:"

# Логи cron
sudo grep CRON /var/log/cron

# Проверка команды вручную
bash -x /path/to/command.sh

# Статус службы cron
sudo systemctl status crond
```

## 📋 Требования

### Windows
- PowerShell 5.1+
- Права администратора
- Task Scheduler (встроен в Windows)

### RedOS / Linux
- Bash 4.0+
- cron (yum install cronie / apt install cron)
- Права root (sudo)
- RedOS 7.3+ / CentOS 7+ / RHEL 7+ / Ubuntu 18.04+

## ⚠️ Безопасность

- Скрипты требуют root/администраторских прав — это нормально для управления системными задачами
- Все команды логируются в указанные log-файлы
- На Windows используется безопасное хранение учетных данных (если требуются)

## 🤝 Вклад в проект

PR приветствуются! Основные направления:
- Поддержка systemd timers (альтернатива cron)
- Web-интерфейс для управления
- Интеграция с Telegram для уведомлений
- Метрики и мониторинг выполнения

## 📄 Лицензия

MIT License — свободное использование в коммерческих и некоммерческих проектах. См. файл [LICENSE](LICENSE).

## 👤 Автор

Created for workflow automation.

---

**🔗 Репозиторий:** https://github.com/sanyakrechin/task-scheduler-automation

**💡 Вопросы и предложения:** Создавайте Issue в репозитории.
