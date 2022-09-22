Param ($commitMessage = $(throw "commit message parameter is required."))

function Invoke-Utility {
  $exe, $argsForExe = $Args
  # Workaround: Prevents 2> redirections applied to calls to this function
  #             from accidentally triggering a terminating error.
  #             See bug report at https://github.com/PowerShell/PowerShell/issues/4002
  $ErrorActionPreference = 'Continue'
  try { & $exe $argsForExe } catch { Throw } # catch is triggered ONLY if $exe can't be found, never for errors reported by $exe itself
  if ($LASTEXITCODE) { Throw "$exe indicated failure (exit code $LASTEXITCODE; full command: $Args)." }
}

Set-Alias iu Invoke-Utility

iu git checkout master
iu git add -A
iu git commit -m $commitMessage
iu git push
npm run build
iu git add dist -f
# -m specifies the commit message
git commit -m 'adding dist subtree' 
#The prefix option specifies the folder that we want for our the subtree. 
iu git subtree push --prefix dist origin gh-pages
write-host ""
write-host "deployed to github"
write-host ""


<#
                                    Invoke Utility 
-------------------------------------------------------------------------------------------------
.SYNOPSIS
Invokes an external utility, ensuring successful execution.

.DESCRIPTION
Invokes an external utility (program) and, if the utility indicates failure by 
way of a nonzero exit code, throws a script-terminating error.

* Pass the command the way you would execute the command directly.
* Do NOT use & as the first argument if the executable name is not a literal.

.EXAMPLE
Invoke-Utility git push

Executes `git push` and throws a script-terminating error if the exit code
is nonzero.
#>