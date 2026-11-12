# Builds the "Anchors Arcade" logo:
#   logo.svg      - theme-aware SVG (fills use CSS vars; recolors with the site theme)
#   favicon.png   - 256px raster in the DEFAULT (purple) theme
#   logo.png      - 512px raster
# Pixel legend: . = transparent, R = main accent, D = dark shade, L = light highlight

$ErrorActionPreference = 'Stop'
$dir = $PSScriptRoot

$map = @(
    '................',
    '.....LRRR.......',
    '....RLRRRD......',
    '....RRRRRD......',
    '.....RRRD.......',
    '.......DD.......',
    '..RRRRRRRRRRDD..',
    '......RRRR......',
    '......RRRR......',
    '......RRRR......',
    '.RR...RRRR...DR.',
    '.RRR..RRRR..DRR.',
    '..RRRRRRRRRRDD..',
    '....RRRRRRDD....',
    '......RRRR......',
    '................'
)

# SVG fills use CSS variables (with fallbacks) so the logo recolors with the theme
$svgFill = @{
    'R' = 'var(--acc, #a855f7)'
    'D' = 'var(--acc-deep, #6b21a8)'
    'L' = 'var(--acc2, #d8b4fe)'
}

# raster PNGs use the default theme (purple)
$pngColors = @{
    'R' = '#a855f7'
    'D' = '#6b21a8'
    'L' = '#d8b4fe'
}

# ---- SVG ----
$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="512" height="512" shape-rendering="crispEdges">')
foreach ($row in $map) {
    $y = $map.IndexOf($row)
    for ($x = 0; $x -lt $row.Length; $x++) {
        $ch = [string]$row[$x]
        if ($svgFill.ContainsKey($ch)) {
            [void]$sb.AppendLine(('  <rect x="{0}" y="{1}" width="1" height="1" fill="{2}"/>' -f $x, $y, $svgFill[$ch]))
        }
    }
}
[void]$sb.AppendLine('</svg>')
Set-Content -Path (Join-Path $dir 'logo.svg') -Value $sb.ToString() -Encoding UTF8

# ---- PNG rasters ----
Add-Type -AssemblyName System.Drawing
foreach ($size in @(256, 512)) {
    $scale = $size / 16
    $bmp = New-Object System.Drawing.Bitmap($size, $size)
    for ($y = 0; $y -lt 16; $y++) {
        for ($x = 0; $x -lt 16; $x++) {
            $ch = [string]$map[$y][$x]
            if ($pngColors.ContainsKey($ch)) {
                $c = [System.Drawing.ColorTranslator]::FromHtml($pngColors[$ch])
                $brush = New-Object System.Drawing.SolidBrush($c)
                $rect = New-Object System.Drawing.Rectangle(($x * $scale), ($y * $scale), $scale, $scale)
                $g = [System.Drawing.Graphics]::FromImage($bmp)
                $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
                $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
                $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
                $g.FillRectangle($brush, $rect)
                $g.Dispose(); $brush.Dispose()
            }
        }
    }
    $name = if ($size -eq 256) { 'favicon.png' } else { 'logo.png' }
    $bmp.Save((Join-Path $dir $name), [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}
Write-Output "Logo built: logo.svg (theme-aware), favicon.png (256px purple), logo.png (512px purple)"
