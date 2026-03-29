#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Просмотр списка задач
.DESCRIPTION
    Выводит все задачи или ищет по имени
.PARAMETER TaskName
    Имя задачи для поиска (опционально)
.EXAMPLE
    .\list-tasks.ps1
    .\list-tasks.ps1 -TaskName "Rdt"
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$TaskName = ""
)

Write-Host ""
Write-Host "📋 Список задач Task Scheduler" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Gray

if ($TaskName) {
    $Tasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "*$TaskName*" }
} else {
    $Tasks = Get-ScheduledTask | Where-Object { $_.TaskName -notlike "Microsoft*" -and $_.TaskName -notlike "*Compatibility*" }
}

if (!$Tasks) {
    Write-Host "❌ Задачи не найдены" -ForegroundColor Yellow
    exit 0
}

$Tasks | ForEach-Object {
    $Task = Get-ScheduledTask -TaskName $_.TaskName
    $TaskInfo = Get-ScheduledTaskInfo -TaskName $_.TaskName
    
    $Status = switch ($Task.State) {
        "Ready" { "✅ Готова" }
        "Running" { "🔄 Выполняется" }
        "Disabled" { "⛔ Отключена" }
        default { "❓ $($Task.State)" }
    }
    
    Write-Host ""
    Write-Host "📌 $($Task.TaskName)" -ForegroundColor Yellow
    Write-Host "   Статус: $Status" -ForegroundColor White
    Write-Host "   Последний запуск: $($TaskInfo.LastRunTime)" -ForegroundColor Gray
    Write-Host "   Следующий запуск: $($TaskInfo.NextRunTime)" -ForegroundColor Gray
    Write-Host "   Действие: $($Task.Actions.Execute)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "📝 Всего задач: $($Tasks.Count)" -ForegroundColor Cyan
