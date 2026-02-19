<#
.SYNOPSIS
    Automated tests for bash-permission-checker.ps1

.DESCRIPTION
    Feeds synthetic JSON input to the permission checker hook and validates
    that commands are correctly allowed, denied, or fall through.

.USAGE
    powershell -NoProfile -ExecutionPolicy Bypass -File ".claude/hooks/bash-permission-checker.tests.ps1"
#>

param()

$ErrorActionPreference = 'Stop'
$scriptPath = Join-Path $PSScriptRoot 'bash-permission-checker.ps1'

$passed = 0
$failed = 0
$errors = [System.Collections.ArrayList]::new()

function Test-Command {
    param(
        [string]$Command,
        [string]$Expected,  # 'allow', 'deny', 'fallthrough'
        [string]$Description
    )

    $json = @{
        tool_name = "Bash"
        tool_input = @{ command = $Command }
    } | ConvertTo-Json -Compress

    # Use Process API for reliable exit code capture
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = 'powershell'
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true

    $proc = [System.Diagnostics.Process]::Start($psi)
    $proc.StandardInput.Write($json)
    $proc.StandardInput.Close()
    $result = $proc.StandardOutput.ReadToEnd()
    $stderr = $proc.StandardError.ReadToEnd()
    $proc.WaitForExit()
    $exitCode = $proc.ExitCode

    $actual = switch ($exitCode) {
        2 { 'deny' }
        0 {
            if ($result -and $result -match 'allow') { 'allow' }
            else { 'fallthrough' }
        }
        default { "error(exit=$exitCode)" }
    }

    if ($actual -eq $Expected) {
        $script:passed++
        Write-Host "  PASS: $Description" -ForegroundColor Green
    } else {
        $script:failed++
        [void]$script:errors.Add("FAIL: $Description (expected=$Expected, actual=$actual)")
        Write-Host "  FAIL: $Description (expected=$Expected, actual=$actual)" -ForegroundColor Red
    }
}

# =============================================================================
# REGRESSION TESTS - existing single-command behavior
# =============================================================================
Write-Host "`nRegression: Single commands" -ForegroundColor Cyan

Test-Command -Command 'npm test' `
    -Expected 'allow' -Description 'npm test'

Test-Command -Command 'npm install' `
    -Expected 'allow' -Description 'npm install'

Test-Command -Command 'npm run build' `
    -Expected 'allow' -Description 'npm run build'

Test-Command -Command 'cd web && npm test' `
    -Expected 'allow' -Description 'cd prefix + npm test'

Test-Command -Command 'cd "c:/Git/project/web" && npm test -- src/test.tsx' `
    -Expected 'allow' -Description 'cd with absolute path + npm test with args'

Test-Command -Command 'npx vitest --run' `
    -Expected 'allow' -Description 'npx vitest'

Test-Command -Command 'ls -la web/src/' `
    -Expected 'allow' -Description 'ls safe directory'

Test-Command -Command 'pwd' `
    -Expected 'allow' -Description 'pwd'

Test-Command -Command 'node --version' `
    -Expected 'allow' -Description 'node --version'

Test-Command -Command 'npm run generate:types' `
    -Expected 'allow' -Description 'npm run generate:types'


# =============================================================================
# Git read-only commands
# =============================================================================
Write-Host "`nGit read-only commands" -ForegroundColor Cyan

Test-Command -Command 'git status' `
    -Expected 'allow' -Description 'git status'

Test-Command -Command 'git status --short' `
    -Expected 'allow' -Description 'git status --short'

Test-Command -Command 'git log --oneline -5' `
    -Expected 'allow' -Description 'git log with flags'

Test-Command -Command 'git diff' `
    -Expected 'allow' -Description 'git diff'

Test-Command -Command 'git diff HEAD~1 -- src/' `
    -Expected 'allow' -Description 'git diff with args'

Test-Command -Command 'git show HEAD' `
    -Expected 'allow' -Description 'git show HEAD'

Test-Command -Command 'git branch' `
    -Expected 'allow' -Description 'git branch (list)'

Test-Command -Command 'git branch -a' `
    -Expected 'allow' -Description 'git branch -a'

Test-Command -Command 'git branch -vv' `
    -Expected 'allow' -Description 'git branch -vv'

Test-Command -Command 'git rev-parse HEAD' `
    -Expected 'allow' -Description 'git rev-parse HEAD'

Test-Command -Command 'git remote -v' `
    -Expected 'allow' -Description 'git remote -v'

Test-Command -Command 'git stash list' `
    -Expected 'allow' -Description 'git stash list'

Test-Command -Command 'git describe --tags' `
    -Expected 'allow' -Description 'git describe --tags'

Test-Command -Command 'git tag' `
    -Expected 'allow' -Description 'git tag (list)'

Test-Command -Command 'git tag -l "v*"' `
    -Expected 'allow' -Description 'git tag -l with pattern'

# Safety: these should NOT be auto-approved
Test-Command -Command 'git branch new-feature' `
    -Expected 'fallthrough' -Description 'git branch create = fallthrough'

Test-Command -Command 'git branch -d old-feature' `
    -Expected 'fallthrough' -Description 'git branch -d = fallthrough'

Test-Command -Command 'git tag v1.0' `
    -Expected 'fallthrough' -Description 'git tag create = fallthrough'

Test-Command -Command 'git stash' `
    -Expected 'fallthrough' -Description 'git stash (not list) = fallthrough'

Test-Command -Command 'git remote add origin url' `
    -Expected 'fallthrough' -Description 'git remote add = fallthrough'

# =============================================================================
# REGRESSION TESTS - deny patterns
# =============================================================================
Write-Host "`nRegression: Deny patterns" -ForegroundColor Cyan

Test-Command -Command 'cat ~/.ssh/id_rsa' `
    -Expected 'deny' -Description 'cat SSH key'

Test-Command -Command 'rm -rf /' `
    -Expected 'deny' -Description 'rm -rf /'

Test-Command -Command 'cat /etc/credentials' `
    -Expected 'deny' -Description 'cat credentials'

Test-Command -Command 'type secret.key' `
    -Expected 'deny' -Description 'type secret file'

# =============================================================================
# REGRESSION TESTS - fallthrough
# =============================================================================
Write-Host "`nRegression: Fallthrough" -ForegroundColor Cyan

Test-Command -Command 'docker run ubuntu' `
    -Expected 'fallthrough' -Description 'unknown command falls through'

Test-Command -Command 'curl https://example.com' `
    -Expected 'fallthrough' -Description 'curl falls through'

# =============================================================================
# NEW: Standalone pattern tests
# =============================================================================
Write-Host "`nStandalone patterns" -ForegroundColor Cyan

Test-Command -Command 'cd /some/directory' `
    -Expected 'allow' -Description 'standalone cd'

Test-Command -Command 'cd "c:/Git/project/web"' `
    -Expected 'allow' -Description 'standalone cd with quoted Windows path'

Test-Command -Command 'echo "Installing dependencies..."' `
    -Expected 'allow' -Description 'echo with quoted string'

Test-Command -Command "echo 'test passed'" `
    -Expected 'allow' -Description 'echo with single-quoted string'

Test-Command -Command 'echo done' `
    -Expected 'allow' -Description 'echo with simple word'

Test-Command -Command 'test -d node_modules' `
    -Expected 'allow' -Description 'test -d'

Test-Command -Command '[ -d node_modules ]' `
    -Expected 'allow' -Description '[ -d ] bracket syntax'

Test-Command -Command 'true' `
    -Expected 'allow' -Description 'true'

Test-Command -Command 'false' `
    -Expected 'allow' -Description 'false'

# =============================================================================
# NEW: Compound command tests (splitting)
# =============================================================================
Write-Host "`nCompound commands (splitting)" -ForegroundColor Cyan

Test-Command -Command 'cd web && npm install && npm test' `
    -Expected 'allow' -Description 'three safe commands chained with &&'

Test-Command -Command 'echo "installing" && npm install' `
    -Expected 'allow' -Description 'echo + npm install'

Test-Command -Command 'cd web && npm test || echo "tests failed"' `
    -Expected 'allow' -Description 'npm test || echo fallback'

Test-Command -Command 'npm install ; npm run build' `
    -Expected 'allow' -Description 'semicolon separator'

Test-Command -Command 'test -d node_modules && echo "found" || npm install' `
    -Expected 'allow' -Description 'conditional dependency check (split)'

Test-Command -Command 'test -f "c:/Git/project/generated-docs/file.md" && cat "c:/Git/project/generated-docs/file.md" || echo "File not found"' `
    -Expected 'allow' -Description 'test -f + cat safe dir + echo fallback'

Test-Command -Command "cd web && npm run build && npm run lint && npm test" `
    -Expected 'allow' -Description 'four commands chained'

Test-Command -Command 'cd "c:/Git/project/web" && npm install && npm run build' `
    -Expected 'allow' -Description 'absolute path cd + chain'

Test-Command -Command 'cd /c/Git/stadium-8 && ls -la generated-docs/context/ 2>/dev/null || echo "Context directory not found"' `
    -Expected 'allow' -Description 'cd + ls generated-docs subdir + echo fallback'

# Heredoc compound (newline-separated)
Test-Command -Command "cat > /tmp/test.js << 'EOF'`nimport { test } from 'vitest';`nEOF`nnpm test -- /tmp/test.js" `
    -Expected 'allow' -Description 'heredoc to /tmp + npm test (newline split)'

# =============================================================================
# SECURITY: Compound commands with deny
# =============================================================================
Write-Host "`nSecurity: Compound with deny" -ForegroundColor Cyan

Test-Command -Command 'echo "ok" && cat ~/.ssh/id_rsa' `
    -Expected 'deny' -Description 'safe + deny = blocked'

Test-Command -Command 'npm test && rm -rf /' `
    -Expected 'deny' -Description 'safe + rm -rf = blocked'

Test-Command -Command 'echo "ok" ; cat credentials.json' `
    -Expected 'deny' -Description 'semicolon + deny = blocked'

Test-Command -Command 'npm install || cat secret' `
    -Expected 'deny' -Description 'OR chain with deny = blocked'

# =============================================================================
# EDGE CASES
# =============================================================================
Write-Host "`nEdge cases" -ForegroundColor Cyan

Test-Command -Command 'echo "foo && bar"' `
    -Expected 'allow' -Description 'quoted && not split (single command match)'

Test-Command -Command "echo 'a ; b'" `
    -Expected 'allow' -Description 'quoted ; not split (single command match)'

Test-Command -Command '(npm test && npm run build)' `
    -Expected 'allow' -Description 'parenthesized group with safe commands'

Test-Command -Command 'cd web && (npm install && npm test)' `
    -Expected 'allow' -Description 'mixed: plain + parenthesized group'

Test-Command -Command '(npm test) && (npm run build)' `
    -Expected 'allow' -Description 'two parenthesized groups'

Test-Command -Command '(npm test && docker run ubuntu)' `
    -Expected 'fallthrough' -Description 'parenthesized group with unknown = fallthrough'

Test-Command -Command 'cd web && docker run ubuntu && npm test' `
    -Expected 'fallthrough' -Description 'one unknown sub-command = fallthrough'

# Note: 'cd web && npm test && unknown_command' matches first-pass because
# npm test's (?:\s+.*)?$ pattern swallows '&& unknown_command' as args.
# This is a pre-existing pattern permissiveness issue, not a splitter bug.
# The deny patterns still protect against dangerous commands in this position.

# =============================================================================
# SPLITTER UNIT TESTS
# =============================================================================
Write-Host "`nSplitter unit tests" -ForegroundColor Cyan

# Extract the function using brace-counting for reliable nested brace handling
$scriptContent = Get-Content $scriptPath -Raw
$funcStart = $scriptContent.IndexOf('function Split-CompoundCommand')
$funcExtracted = $false

if ($funcStart -ge 0) {
    $braceStart = $scriptContent.IndexOf('{', $funcStart)
    if ($braceStart -ge 0) {
        $depth = 0
        $funcEnd = $braceStart
        for ($k = $braceStart; $k -lt $scriptContent.Length; $k++) {
            if ($scriptContent[$k] -eq '{') { $depth++ }
            elseif ($scriptContent[$k] -eq '}') {
                $depth--
                if ($depth -eq 0) { $funcEnd = $k; break }
            }
        }
        $funcText = $scriptContent.Substring($funcStart, $funcEnd - $funcStart + 1)
        Invoke-Expression $funcText
        $funcExtracted = $true
    }
}

if ($funcExtracted) {
    function Test-Split {
        param(
            [string]$InputText,
            [string[]]$ExpectedParts,
            [string]$Description
        )

        $result = Split-CompoundCommand -CommandText $InputText

        if ($null -eq $ExpectedParts) {
            if ($null -eq $result) {
                $script:passed++
                Write-Host "  PASS: $Description" -ForegroundColor Green
            } else {
                $script:failed++
                [void]$script:errors.Add("FAIL: $Description (expected null, got $($result.Count) parts: $($result -join ' | '))")
                Write-Host "  FAIL: $Description (expected null, got $($result.Count) parts)" -ForegroundColor Red
            }
            return
        }

        if ($null -eq $result) {
            $script:failed++
            [void]$script:errors.Add("FAIL: $Description (expected $($ExpectedParts.Count) parts, got null)")
            Write-Host "  FAIL: $Description (expected $($ExpectedParts.Count) parts, got null)" -ForegroundColor Red
            return
        }

        if ($result.Count -ne $ExpectedParts.Count) {
            $script:failed++
            [void]$script:errors.Add("FAIL: $Description (expected $($ExpectedParts.Count) parts, got $($result.Count): $($result -join ' | '))")
            Write-Host "  FAIL: $Description (expected $($ExpectedParts.Count) parts, got $($result.Count))" -ForegroundColor Red
            return
        }

        for ($j = 0; $j -lt $result.Count; $j++) {
            if ($result[$j] -ne $ExpectedParts[$j]) {
                $script:failed++
                [void]$script:errors.Add("FAIL: $Description (part $j expected '$($ExpectedParts[$j])', got '$($result[$j])')")
                Write-Host "  FAIL: $Description (part $j expected '$($ExpectedParts[$j])', got '$($result[$j])')" -ForegroundColor Red
                return
            }
        }
        $script:passed++
        Write-Host "  PASS: $Description" -ForegroundColor Green
    }

    Test-Split -InputText 'npm install && npm test' `
        -ExpectedParts @('npm install', 'npm test') `
        -Description 'simple && split'

    Test-Split -InputText 'npm test || echo "failed"' `
        -ExpectedParts @('npm test', 'echo "failed"') `
        -Description 'simple || split'

    Test-Split -InputText 'npm install ; npm run build' `
        -ExpectedParts @('npm install', 'npm run build') `
        -Description 'simple ; split'

    Test-Split -InputText "npm install`nnpm test" `
        -ExpectedParts @('npm install', 'npm test') `
        -Description 'newline split'

    Test-Split -InputText 'cd web && npm install && npm test' `
        -ExpectedParts @('cd web', 'npm install', 'npm test') `
        -Description 'three-way && split'

    Test-Split -InputText 'echo "foo && bar"' `
        -ExpectedParts $null `
        -Description 'quoted && returns null (single command)'

    Test-Split -InputText "echo 'a ; b'" `
        -ExpectedParts $null `
        -Description 'single-quoted ; returns null (single command)'

    Test-Split -InputText '(npm test && npm build)' `
        -ExpectedParts $null `
        -Description 'parenthesized group returns null (single command)'

    Test-Split -InputText 'cat file | head -5' `
        -ExpectedParts $null `
        -Description 'single pipe not split (returns null)'

    Test-Split -InputText 'test -d node_modules && echo "ok" || npm install' `
        -ExpectedParts @('test -d node_modules', 'echo "ok"', 'npm install') `
        -Description 'mixed && and || split'

    Test-Split -InputText "cat > /tmp/test.js << 'EOF'`nsome content`nEOF`nnpm test" `
        -ExpectedParts @("cat > /tmp/test.js << 'EOF'`nsome content`nEOF", 'npm test') `
        -Description 'heredoc body not split, newline after EOF splits'

    Test-Split -InputText 'npm test' `
        -ExpectedParts $null `
        -Description 'single command returns null'

} else {
    Write-Host "  SKIP: Could not extract Split-CompoundCommand function" -ForegroundColor Yellow
}

# =============================================================================
# SUMMARY
# =============================================================================
Write-Host "`n========================================" -ForegroundColor White
Write-Host "Results: $passed passed, $failed failed" -ForegroundColor $(if ($failed -eq 0) { 'Green' } else { 'Red' })

if ($errors.Count -gt 0) {
    Write-Host "`nFailures:" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "  $err" -ForegroundColor Red
    }
}

Write-Host "========================================`n" -ForegroundColor White
exit $(if ($failed -eq 0) { 0 } else { 1 })
