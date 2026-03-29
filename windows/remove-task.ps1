#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Удаление задачи из Task Scheduler
.DESCRIPTION
    Удаляет задачу по имени
.PARAMETER TaskName
    Имя задачи для удаления
.EXAMPLE
    .\remove-task.ps1 -TaskName "RdtLoader"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$TaskName
)

$ExistingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue

if (!$ExistingTask) {
    Write-Host "❌ Задача '$TaskName' не найдена" -ForegroundColor Red
    exit 1
}

try {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    Write-Host "✅ Задача '$TaskName' успешно удалена!" -ForegroundColor Green
} catch {
    Write-Host "❌ Ошибка при удалении задачи: $_" -ForegroundColor Red
    exit 1
}
