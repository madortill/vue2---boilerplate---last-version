  # set url parameter
  Param ($repoURL = $(throw "repository url parameter is required."))
  $repoName = ((($repoURL -split "/")[4]) -split ("\."))[0]  
  write-output "Your repository name:  $repoName"

# catch git errors function
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

# make sure the user wants to run the command
$confirmation = Read-Host "This command will delete all git history. Do it only when you want to create new repository. Are you Sure You Want To Proceed [y/n]"
if ($confirmation -eq 'y') {
  (Get-Content ./vite.config.js).replace('<REPO_NANE>', $repoName) | Set-Content ./vite.config.js


  npm i
  Remove-Item -Path .git -Force -Recurse:$true
  iu git init
  # make sure there isn't any registered remote
  iu git add -A
  git remote add origin $repoURL
  git checkout -b master
  iu git commit -m 'first' 
  iu git push -u origin master
  write-output ""
  write-output "Repositry initalized"

}

