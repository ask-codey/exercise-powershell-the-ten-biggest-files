# Checks the six reports and the renamed screenshots, one test per task in README.md.
# Run it from this folder with: Invoke-Pester
# You don't need to change this file.

BeforeAll {
    $script:laptop = Join-Path $PSScriptRoot 'old-laptop'

    # The non-empty lines of a report in this folder, trimmed, or $null when the file isn't there.
    function Get-ReportLines([string] $name) {
        $path = Join-Path $PSScriptRoot $name
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return $null }
        @(Get-Content -LiteralPath $path | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' })
    }

    # What a report holds, as one line of text for a test's message.
    function Show-Report([string] $name) {
        $lines = Get-ReportLines $name
        if ($null -eq $lines) { return "(no $name)" }
        if ($lines.Count -eq 0) { return "($name is empty)" }
        $lines -join ', '
    }

    $script:biggest = 'graduation.mp4, old-photos.zip, first-steps.mp4, driver-installer.exe, movie-trailer.mp4, concert-clip.mp4, podcast-episode-13.mp3, podcast-episode-12.mp3, beach-day.jpg, family-dinner.jpg'
    $script:sizes = [ordered]@{
        'graduation.mp4' = 945; 'old-photos.zip' = 750; 'first-steps.mp4' = 630; 'driver-installer.exe' = 575
        'movie-trailer.mp4' = 540; 'concert-clip.mp4' = 495; 'podcast-episode-13.mp3' = 455
        'podcast-episode-12.mp3' = 440; 'beach-day.jpg' = 415; 'family-dinner.jpg' = 380
    }
    $script:types = @{ '.mp4' = 5; '.mp3' = 4; '.png' = 4; '.pdf' = 3; '.docx' = 2; '.exe' = 2; '.jpg' = 2; '.tmp' = 1; '.zip' = 1 }
}

Describe 'Exercise: The Ten Biggest Files' {

    It '1) count.txt holds how many files the laptop has' {
        Show-Report 'count.txt' | Should -Be '24' -Because 'task 1 counts every file in old-laptop and every folder inside it with Measure-Object, and writes only the number into count.txt: (... | Measure-Object).Count. Run it from this folder, and use -Recurse and -File'
    }

    It '2) biggest.txt lists the ten biggest files, biggest first' {
        Show-Report 'biggest.txt' | Should -Be $biggest -Because 'task 2 sorts every file by Length, biggest first, keeps the first ten, and writes only their names, one a line (Select-Object -First 10 -ExpandProperty Name)'
    }

    It '3) big-videos.txt lists the .mp4 files over 500 KB, smallest first' {
        Show-Report 'big-videos.txt' | Should -Be 'movie-trailer.mp4, first-steps.mp4, graduation.mp4' -Because 'task 3 keeps the files whose Extension is .mp4 and whose Length is greater than 500KB, sorts them smallest first and writes their names. Write 500KB, not 500000: PowerShell''s KB is 1,024 bytes, so 500KB is 512,000'
    }

    It '4) types.txt counts the files of each type, most first' {
        $lines = Get-ReportLines 'types.txt'
        $found = [ordered]@{}
        foreach ($line in @($lines)) { if ($line -match '^(\d+)\s+(\.\w+)$') { $found[$Matches[2]] = [int]$Matches[1] } }
        $shown = if ($found.Count) { ($found.GetEnumerator() | ForEach-Object { "$($_.Value) $($_.Key)" }) -join ', ' } else { Show-Report 'types.txt' }
        $want = ($types.GetEnumerator() | Sort-Object { -$_.Value }, Key | ForEach-Object { "$($_.Value) $($_.Key)" }) -join ', '
        $sameCounts = $found.Count -eq $types.Count -and -not @($types.Keys | Where-Object { $found[$_] -ne $types[$_] })
        $sameCounts | Should -BeTrue -Because "task 4 groups every file by Extension with Group-Object and writes the Count and Name of each group into types.txt (Group-Object -NoElement keeps only those two). Expected: $want. But was: $shown"
        $counts = @($found.Values)
        $mostFirst = -not @(1..($counts.Count - 1) | Where-Object { $counts[$_] -gt $counts[$_ - 1] })
        $mostFirst | Should -BeTrue -Because "the groups go most first: Sort-Object Count -Descending. But was: $shown"
    }

    It '5) sizes.txt shows the ten biggest with a SizeKB column, rounded' {
        $lines = Get-ReportLines 'sizes.txt'
        $rows = @(@($lines) | Where-Object { $_ -match '^(\S+)\s+(\d+(\.\d+)?)$' } | ForEach-Object {
            $null = $_ -match '^(\S+)\s+(\d+(\.\d+)?)$'
            "$($Matches[1]) $([double]::Parse($Matches[2], [cultureinfo]::InvariantCulture))"
        })
        $want = ($sizes.GetEnumerator() | ForEach-Object { "$($_.Key) $($_.Value)" }) -join ', '
        $shown = if ($rows.Count) { $rows -join ', ' } else { Show-Report 'sizes.txt' }
        $shown | Should -Be $want -Because 'task 5 writes the ten biggest files, biggest first, with their Name and a calculated property SizeKB: the Length divided by 1KB, rounded to a whole number with [math]::Round. Unrounded, a size such as 944.82 shows instead of 945'
    }

    It '6) the screenshots are renamed screenshot-1.png to screenshot-4.png' {
        $pictures = Join-Path $laptop 'Pictures'
        $names = (@(Get-ChildItem -LiteralPath $pictures -File | ForEach-Object Name) | Sort-Object) -join ', '
        $names | Should -BeExactly 'beach-day.jpg, family-dinner.jpg, screenshot-1.png, screenshot-2.png, screenshot-3.png, screenshot-4.png' -Because 'task 6 renames every Screenshot_ file in old-laptop\Pictures so its name starts with screenshot- instead, with ForEach-Object and .Replace(''Screenshot_'', ''screenshot-''). Rehearse with -WhatIf inside the braces first'
    }
}
