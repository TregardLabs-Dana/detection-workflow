#!/bin/bash
# scripts/notify-complete.sh - Stop hook that shows a non-blocking Windows
# tray balloon notification instead of a modal dialog.

powershell -NoProfile -NonInteractive -Command '
Add-Type -AssemblyName System.Windows.Forms
$n = New-Object System.Windows.Forms.NotifyIcon
$n.Icon = [System.Drawing.SystemIcons]::Information
$n.Visible = $true
$n.ShowBalloonTip(3000, "Claude Code", "Task complete!", "Info")
Start-Sleep -Seconds 4
$n.Dispose()
'

exit 0
