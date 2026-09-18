<#
  photo-to-ascii.ps1
  Convert a photo into ASCII art rendered as SVG <tspan> lines, matching the
  green terminal look of dark.svg's WORLD.MAP panel.

  Usage:
    powershell -File photo-to-ascii.ps1 -Path C:\path\to\photo.jpg `
        -Cols 90 -X 30 -Y0 70 -LineHeight 6 [-Invert] [-Preview]

  Params:
    -Path        source image (jpg/png)
    -Cols        number of characters per row (default 90)
    -X           x coordinate for each tspan (default 30)
    -Y0          y coordinate of the first row (default 70)
    -LineHeight  vertical spacing between rows in px (default 6)
    -Invert      flip the brightness->density mapping
    -Preview     also print a plain-text preview to the console
#>
param(
  [Parameter(Mandatory=$true)][string]$Path,
  [int]$Cols = 90,
  [int]$X = 30,
  [int]$Y0 = 70,
  [double]$LineHeight = 6,
  [switch]$Invert,
  [switch]$Preview
)

Add-Type -AssemblyName System.Drawing

if (-not (Test-Path -LiteralPath $Path)) {
  Write-Error "Image not found: $Path"; exit 1
}

# Brightness ramp: index 0 = darkest ink coverage, last = densest.
# On a dark SVG background with light green text, denser chars read as brighter.
$ramp = ' .`:-=+*#%@'
$rampLen = $ramp.Length

$src = [System.Drawing.Image]::FromFile((Resolve-Path -LiteralPath $Path).Path)
try {
  # Monospace glyphs are ~2x taller than wide, so halve the row count to keep
  # the aspect ratio looking correct.
  $rows = [int][math]::Round($Cols * ($src.Height / $src.Width) * 0.5)
  if ($rows -lt 1) { $rows = 1 }

  $bmp = New-Object System.Drawing.Bitmap $Cols, $rows
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.DrawImage($src, 0, 0, $Cols, $rows)
  $g.Dispose()

  $tspans = New-Object System.Text.StringBuilder
  $plain  = New-Object System.Text.StringBuilder

  for ($r = 0; $r -lt $rows; $r++) {
    $line = New-Object System.Text.StringBuilder
    for ($c = 0; $c -lt $Cols; $c++) {
      $px = $bmp.GetPixel($c, $r)
      # Rec. 601 luma
      $lum = (0.299 * $px.R + 0.587 * $px.G + 0.114 * $px.B) / 255.0
      if ($Invert) { $lum = 1.0 - $lum }
      $idx = [int][math]::Round($lum * ($rampLen - 1))
      if ($idx -lt 0) { $idx = 0 }
      if ($idx -ge $rampLen) { $idx = $rampLen - 1 }
      [void]$line.Append($ramp[$idx])
    }
    $raw = $line.ToString()
    [void]$plain.AppendLine($raw)

    # XML-escape for SVG
    $esc = $raw.Replace('&','&amp;').Replace('<','&lt;').Replace('>','&gt;')
    $y = $Y0 + [int][math]::Round($r * $LineHeight)
    [void]$tspans.AppendLine("<tspan x=`"$X`" y=`"$y`" xml:space=`"preserve`">$esc</tspan>")
  }

  $bmp.Dispose()

  if ($Preview) {
    Write-Host "----- PREVIEW ($Cols x $rows) -----"
    Write-Host $plain.ToString()
    Write-Host "----- END PREVIEW -----"
  }

  # Emit the SVG tspans to stdout (and a sidecar file next to the image)
  $outFile = [System.IO.Path]::ChangeExtension($Path, '.ascii.svgfrag')
  Set-Content -LiteralPath $outFile -Value $tspans.ToString() -Encoding UTF8
  Write-Host "Wrote SVG fragment ($rows rows) to: $outFile"
}
finally {
  $src.Dispose()
}
