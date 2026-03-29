#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Создание периодической задачи в Task Scheduler (Windows)
.DESCRIPTION
    Создает задачу которая запускает команду с заданным интервалом
.PARAMETER TaskName
    Имя задачи
.PARAMETER IntervalMinutes
    Интервал в минутах
.PARAMETER Command
    Команда для выполнения
.PARAMETER LogFile
    Путь к лог-файлу
.EXAMPLE
    .\install-task.ps1 -TaskName "RdtLoader" -IntervalMinutes 60 -Command "date" -LogFile "C:\Logs\rdt.log"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$TaskName,
    
    [Parameter(Mandatory=$true)]
    [int]$IntervalMinutes,
    
    [Parameter(Mandatory=$true)]
    [string]$Command,
    
    [Parameter(Mandatory=$false)]
    [string]$LogFile = "C:\Logs\task.log"
)

# Создаем директорию для логов если не существует
$LogDir = Split-Path -Parent $LogFile
if (!(Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
    Write-Host "✅ Создана директория: $LogDir" -ForegroundColor Green
}

# Формируем команду для записи в лог
# Для PowerShell: дата и время в лог
$ActionCommand = "powershell.exe"
$ActionArgs = "-Command `"& {`$date = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'; `$date | Out-File -Append -FilePath '$LogFile'; & $Command 2>&1 | Out-File -Append -FilePath '$LogFile'; '---' | Out-File -Append -FilePath '$LogFile'}`""

# Создаем действие
$Action = New-ScheduledTaskAction -Execute $ActionCommand -Argument $ActionArgs

# Создаем триггер (повторяющийся с интервалом)
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes $IntervalMinutes) -RepetitionDuration (New-TimeSpan -Days 3650)

# Настройки задачи
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Проверяем существование задачи
$ExistingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($ExistingTask) {
    Write-Host "⚠️ Задача '$TaskName' уже существует. Удаляем..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

# Регистрируем задачу
Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Settings $Settings -Force | Out-Null

Write-Host "✅ Задача '$TaskName' успешно создана!" -ForegroundColor Green
Write-Host "   📅 Интервал: каждые $IntervalMinutes минут" -ForegroundColor Cyan
Write-Host "   📁 Лог-файл: $LogFile" -ForegroundColor Cyan
Write-Host "   ⚙️ Команда: $Command" -ForegroundColor Cyan
