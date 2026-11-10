# Exercise: The Ten Biggest Files

Exercise code for the lesson **Exercise: The Ten Biggest Files** in PowerShell in Depth on [ask-codey.com](https://www.ask-codey.com).

A cousin's old laptop is full, and before anyone deletes anything you've been asked what's taking up the space. The `old-laptop` folder here is a copy of its files: 24 made-up documents, downloads, songs, pictures and videos. You'll answer six questions about it with the pipeline, each answer saved as a small report, and a Pester check tells you which ones are right.

## What's here

- `old-laptop/`: the laptop's 24 files, in five folders. They hold only the letter x, over and over, so each has a real size but nothing to open. For you to measure, and in task 6 to tidy.
- `Check.Tests.ps1`: the check that reads your reports and looks at the `Pictures` folder. You don't need to change it.

## What to do

Open PowerShell 7 in this folder, the one with `Check.Tests.ps1` in it. Run every command from here, and write every report here too, beside `Check.Tests.ps1`, not inside `old-laptop`. Use the commands from the chapter *The Pipeline*: `Where-Object`, `Sort-Object`, `Select-Object`, `Measure-Object`, `Group-Object`, `ForEach-Object` and calculated properties, with `Set-Content` or `Out-File` at the end to save each answer.

1. **How many files?** Count every file in `old-laptop` and in every folder inside it. Write the number into `count.txt`.
2. **The ten biggest.** Write the names of the ten biggest files into `biggest.txt`, biggest first, one name a line, and nothing else.
3. **The big videos.** Write the names of the videos (`.mp4` files) over 500 KB into `big-videos.txt`, smallest first, one name a line.
4. **What kinds of files?** Group the files by their extension, and write each group's Count and Name into `types.txt`, the biggest group first.
5. **Sizes people can read.** Write the ten biggest files into `sizes.txt` as a table with two columns: `Name`, and a column of your own called `SizeKB` holding each file's size in kilobytes, rounded to a whole number.
6. **Tidy the screenshots.** In `old-laptop\Pictures`, rename every file that starts with `Screenshot_` so it starts with `screenshot-` instead: `Screenshot_1.png` becomes `screenshot-1.png`. Do it with one `ForEach-Object`, and rehearse it with `-WhatIf` first.

## Check your work

The check needs Pester 5 or newer. Install it once, if you haven't already:

```powershell
Install-PSResource Pester
```

Then, from this folder:

```powershell
Invoke-Pester
```

At first every test fails: that is expected. Each task you finish turns its test green. A failing test's message says which task it is, what it expected, and what it found.

Made a mistake? Write the report again: `Set-Content` and `Out-File` replace what a file held. If task 6 went wrong, rename the screenshots back the same way. To start over, download the exercise again.

If PowerShell says the check *cannot be loaded because running scripts is disabled* or *is not digitally signed*, the folder came from a download that Windows marked as from the internet. Unblock its files once with `Get-ChildItem -Recurse | Unblock-File`, from this folder, and run `Invoke-Pester` again. *Why a Script Won't Run: The Execution Policy*, in Module 5, explains what that does.

## Tips

- Build each pipeline one step at a time. Look at what each step gives you before you add the next, and save it to a file only when the screen shows the right answer.
- Only the names, one a line: that's `Select-Object -ExpandProperty Name`. A plain `Select-Object Name` writes a table with a heading.
- `500KB` is 500 × 1,024 bytes. `500000` is a little less, and lets one video in that shouldn't be.
- `Group-Object -NoElement` keeps only each group's Count and Name.
- `[math]::Round(…)` with no second number rounds to a whole number.

## Hand it in

When it works, push your solution to a public repo of your own on GitHub, then paste that repo's address into **Submit your exercise** on the lesson page at [ask-codey.com](https://www.ask-codey.com). That's what completes the lesson. The lesson page shows the Git commands, step by step.
