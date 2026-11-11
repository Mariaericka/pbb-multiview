# PBB multiview: bubukas ang 3 Edge app window at ilalagay sa tamang pwesto
$ErrorActionPreference = 'Continue'

Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;
using System.Collections.Generic;
public class W {
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] static extern bool EnumWindows(EnumProc p, IntPtr l);
  [DllImport("user32.dll")] static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr h, int x, int y, int w, int ht, bool r);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int c);
  [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
  public static List<long> Edge() {
    var l = new List<long>();
    EnumWindows((h, x) => {
      if (IsWindowVisible(h)) {
        var s = new StringBuilder(256);
        GetClassName(h, s, 256);
        if (s.ToString() == "Chrome_WidgetWin_1") l.Add(h.ToInt64());
      }
      return true;
    }, IntPtr.Zero);
    return l;
  }
}
"@

[void][W]::SetProcessDPIAware()
Add-Type -AssemblyName System.Windows.Forms
$a = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea

$mw = [int]($a.Width * 0.6)
$rw = $a.Width - $mw
$rh = [int]($a.Height / 2)
$rx = $a.X + $mw
$by = $a.Y + $rh

function Open-Tile($url, $x, $y, $w, $ht) {
  if (-not $url -or $url -like 'PASTE*') { return }
  $before = [W]::Edge()
  Start-Process msedge -ArgumentList ('--app=' + $url)
  $new = $null
  for ($i = 0; $i -lt 40; $i++) {
    Start-Sleep -Milliseconds 250
    $new = @([W]::Edge() | Where-Object { $before -notcontains $_ })
    if ($new.Count -gt 0) { break }
  }
  if ($new.Count -gt 0) {
    $hwnd = [IntPtr]$new[0]
    [void][W]::ShowWindow($hwnd, 9)
    [void][W]::MoveWindow($hwnd, $x, $y, $w, $ht, $true)
    Start-Sleep -Milliseconds 1500
    [void][W]::MoveWindow($hwnd, $x, $y, $w, $ht, $true)
  } else {
    Write-Host "Hindi nakita ang bagong window para sa: $url"
  }
}

Open-Tile $env:URL1 $a.X $a.Y $mw $a.Height
Open-Tile $env:URL2 $rx  $a.Y $rw $rh
Open-Tile $env:URL3 $rx  $by  $rw $rh
