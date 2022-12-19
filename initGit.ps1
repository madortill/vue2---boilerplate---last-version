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

# check if connected to remote repo
if ((git remote -v) -ne $null) {
  Throw "This repository already exists in github! (has a remote)"
}

# replace <REPO_NAME> value in vite.config.js
  $data = Get-Content ".\vite.config.js"
  $data = $data.Replace("<REPO_NAME>", "$repoName")
  $data | Out-File -encoding ASCII ".\vite.config.js"

  npm i
  iu git init
  iu git remote add origin $repoURL
  iu git add -A
  iu git checkout -b master
  iu git commit -m 'first' 
  iu git push -u origin master
  npm run build
  iu git add dist -f
  git commit -m 'adding dist subtree' 
  #The prefix option specifies the folder that we want for our the subtree. 
  iu git subtree push --prefix dist origin gh-pages
  write-output ""
  write-output "Repositry initalized"


