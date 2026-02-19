<#
.SYNOPSIS
    PreToolUse hook that auto-approves safe Bash commands for Claude Code.

.DESCRIPTION
    Receives tool call JSON via stdin, checks against deny/allow patterns,
    and outputs permission decision JSON.

    Exit codes:
    - 0 with JSON output: Command approved
    - 0 without output: Falls through to normal permission system
    - 2: Block the command

.NOTES
    Location: .claude/hooks/bash-permission-checker.ps1
#>

param()

# Read JSON input from stdin
$inputJson = $null
try {
    $inputJson = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch {
    exit 0
}

# Only process Bash tool calls
if ($inputJson.tool_name -ne "Bash") {
    exit 0
}

$command = $inputJson.tool_input.command
if (-not $command) {
    exit 0
}

# =============================================================================
# COMPOUND COMMAND SPLITTER
# =============================================================================
# Splits compound commands on &&, ||, ;, and newlines while respecting quotes,
# heredocs, and parenthesized groups. Returns $null on ambiguity (safe fallthrough).

function Split-CompoundCommand {
    param([string]$CommandText)

    $commands = [System.Collections.ArrayList]::new()
    $current = [System.Text.StringBuilder]::new()
    $i = 0
    $len = $CommandText.Length
    $state = 'NORMAL'
    $heredocDelimiter = $null
    $parenDepth = 0

    while ($i -lt $len) {
        $c = $CommandText[$i]

        switch ($state) {
            'SINGLE_QUOTE' {
                [void]$current.Append($c)
                if ($c -eq "'") { $state = 'NORMAL' }
                $i++
                continue
            }
            'DOUBLE_QUOTE' {
                [void]$current.Append($c)
                # Handle escaped double quote
                if ($c -eq '\' -and ($i + 1) -lt $len -and $CommandText[$i + 1] -eq '"') {
                    [void]$current.Append($CommandText[$i + 1])
                    $i += 2
                    continue
                }
                if ($c -eq '"') { $state = 'NORMAL' }
                $i++
                continue
            }
            'HEREDOC' {
                [void]$current.Append($c)
                # Check if we're at a newline - the delimiter must be on its own line
                if ($c -eq "`n") {
                    # Look ahead to see if the next line is the delimiter
                    $lineEnd = $CommandText.IndexOf("`n", $i + 1)
                    if ($lineEnd -eq -1) { $lineEnd = $len }
                    $line = $CommandText.Substring($i + 1, $lineEnd - $i - 1).Trim()
                    if ($line -eq $heredocDelimiter) {
                        # Append the delimiter line and exit heredoc state
                        [void]$current.Append($CommandText.Substring($i + 1, $lineEnd - $i - 1))
                        $i = $lineEnd
                        $state = 'NORMAL'
                        $heredocDelimiter = $null
                        continue
                    }
                }
                $i++
                continue
            }
            'NORMAL' {
                # --- Quotes ---
                if ($c -eq "'" -and $parenDepth -eq 0) {
                    [void]$current.Append($c)
                    $state = 'SINGLE_QUOTE'
                    $i++
                    continue
                }
                if ($c -eq '"' -and $parenDepth -eq 0) {
                    [void]$current.Append($c)
                    $state = 'DOUBLE_QUOTE'
                    $i++
                    continue
                }

                # --- Parentheses (track depth, don't split inside) ---
                if ($c -eq '(') {
                    $parenDepth++
                    [void]$current.Append($c)
                    $i++
                    continue
                }
                if ($c -eq ')') {
                    $parenDepth = [Math]::Max(0, $parenDepth - 1)
                    [void]$current.Append($c)
                    $i++
                    continue
                }

                # Only split at depth 0
                if ($parenDepth -gt 0) {
                    [void]$current.Append($c)
                    $i++
                    continue
                }

                # --- Heredoc detection: << [-] ['"]DELIM['"] ---
                if ($c -eq '<' -and ($i + 1) -lt $len -and $CommandText[$i + 1] -eq '<') {
                    [void]$current.Append('<<')
                    $i += 2
                    # Skip optional '-' and whitespace
                    while ($i -lt $len -and ($CommandText[$i] -eq '-' -or $CommandText[$i] -match '\s') -and $CommandText[$i] -ne "`n") {
                        [void]$current.Append($CommandText[$i])
                        $i++
                    }
                    # Extract delimiter (strip surrounding quotes)
                    $quoteChar = $null
                    if ($i -lt $len -and ($CommandText[$i] -eq "'" -or $CommandText[$i] -eq '"')) {
                        $quoteChar = $CommandText[$i]
                        [void]$current.Append($CommandText[$i])
                        $i++
                    }
                    $delimStart = $i
                    while ($i -lt $len -and $CommandText[$i] -match '\w') {
                        [void]$current.Append($CommandText[$i])
                        $i++
                    }
                    $heredocDelimiter = $CommandText.Substring($delimStart, $i - $delimStart)
                    if ($quoteChar -and $i -lt $len -and $CommandText[$i] -eq $quoteChar) {
                        [void]$current.Append($CommandText[$i])
                        $i++
                    }
                    if ($heredocDelimiter.Length -gt 0) {
                        $state = 'HEREDOC'
                    }
                    continue
                }

                # --- Split on && ---
                if ($c -eq '&' -and ($i + 1) -lt $len -and $CommandText[$i + 1] -eq '&') {
                    $trimmed = $current.ToString().Trim()
                    if ($trimmed) { [void]$commands.Add($trimmed) }
                    [void]$current.Clear()
                    $i += 2
                    continue
                }

                # --- Split on || (but NOT single |) ---
                if ($c -eq '|' -and ($i + 1) -lt $len -and $CommandText[$i + 1] -eq '|') {
                    $trimmed = $current.ToString().Trim()
                    if ($trimmed) { [void]$commands.Add($trimmed) }
                    [void]$current.Clear()
                    $i += 2
                    continue
                }

                # --- Split on ; ---
                if ($c -eq ';') {
                    $trimmed = $current.ToString().Trim()
                    if ($trimmed) { [void]$commands.Add($trimmed) }
                    [void]$current.Clear()
                    $i++
                    continue
                }

                # --- Split on newline ---
                if ($c -eq "`n") {
                    $trimmed = $current.ToString().Trim()
                    if ($trimmed) { [void]$commands.Add($trimmed) }
                    [void]$current.Clear()
                    $i++
                    continue
                }

                # --- Single pipe is NOT a split point ---
                [void]$current.Append($c)
                $i++
            }
        }
    }

    # Flush remaining content
    $trimmed = $current.ToString().Trim()
    if ($trimmed) { [void]$commands.Add($trimmed) }

    # Return $null if parsing ended in a non-normal state (ambiguous)
    if ($state -ne 'NORMAL' -or $parenDepth -ne 0) { return $null }

    # Return $null if only 1 command (no point re-checking what already failed first pass)
    if ($commands.Count -le 1) { return $null }

    return [string[]]$commands
}

# =============================================================================
# DENY PATTERNS - checked first, blocks matching commands (exit 2)
# =============================================================================
$denyPatterns = @(
    'rm\s+-rf\s+/',                                                    # Dangerous delete
    '(cat|type|Get-Content|more|less|head|tail|sed|awk).*id_rsa',     # SSH keys
    '(cat|type|Get-Content|more|less|head|tail|sed|awk).*\.pem\b',    # Certificates
    '(cat|type|Get-Content|more|less|head|tail|sed|awk).*credentials', # Credentials
    '(cat|type|Get-Content|more|less|head|tail).*[/\\]\.ssh[/\\]',    # SSH directory
    '(cat|type|Get-Content).*private.*key',                            # Private keys
    '(cat|type|Get-Content).*secret'                                   # Secrets
)

foreach ($pattern in $denyPatterns) {
    if ($command -imatch $pattern) {
        [Console]::Error.WriteLine("Blocked by security policy: Command matches deny pattern")
        exit 2
    }
}

# =============================================================================
# ALLOW PATTERNS - auto-approve safe commands
# =============================================================================
# Supports optional "cd <dir> && " prefix and full Windows paths with quotes

$cdPrefix = '(?:cd\s+["'']?[\w./:~\\-]+["'']?\s*&&\s*)?'
$winPath = '["'']?[\w./:~\\-]*'
$subPath = '[\w./\\-]'

$allowPatterns = @(
    # --- NPM ---
    ($cdPrefix + 'npm\s+ci(?:\s+--[\w-]+)*\s*$'),
    ($cdPrefix + 'npm\s+install(?:\s+--[\w-]+)*\s*$'),
    ($cdPrefix + 'npm\s+i(?:\s+--[\w-]+)*\s*$'),
    ($cdPrefix + 'npm\s+install(?:\s+--[\w-]+)*(?:\s+@types/[\w-]+)+\s*$'),
    ($cdPrefix + 'npm\s+i(?:\s+--[\w-]+)*(?:\s+@types/[\w-]+)+\s*$'),
    ($cdPrefix + 'npm\s+install(?:\s+--[\w-]+)*(?:\s+@radix-ui/[\w-]+)+\s*$'),
    ($cdPrefix + 'npm\s+i(?:\s+--[\w-]+)*(?:\s+@radix-ui/[\w-]+)+\s*$'),
    ($cdPrefix + 'npm\s+test(?:\s+.*)?$'),
    ($cdPrefix + 'npm\s+t(?:\s+.*)?$'),
    ($cdPrefix + 'npm\s+run\s+(build|lint|dev|format|test|typecheck|check|generate)(?::\w+)?(?:\s+.*)?$'),
    ($cdPrefix + 'npm\s+audit(?:\s+.*)?$'),
    # Dependency check with conditional npm install (test -d, [ -d ], if exist + optional echo/npm install)
    ($cdPrefix + '(?:test\s+-d|\[\s+-d)\s+node_modules\s*\]?(?:\s*[&|]+\s*(?:echo\s+["''].*["'']|\(echo\s+["''].*["'']\)|\(?npm\s+install\)?)\s*)*$'),
    ($cdPrefix + 'if\s+exist\s+["'']?node_modules[/\\]?["'']?\s*(?:\(.*\)\s*)?(?:else\s*\(.*\)\s*)?$'),

    # --- NPX ---
    ($cdPrefix + 'npx\s+tsc(?:\s+.*)?$'),
    ($cdPrefix + 'npx\s+shadcn(?:@[\w.]+)?(?:\s+.*)?$'),
    ($cdPrefix + 'npx\s+vitest(?:\s+.*)?$'),
    ($cdPrefix + 'npx\s+next(?:\s+.*)?$'),
    ($cdPrefix + 'npx\s+eslint(?:\s+.*)?$'),
    ($cdPrefix + 'npx\s+prettier(?:\s+.*)?$'),

    # --- Node scripts (safe directories only) ---
    ($cdPrefix + 'node\s+' + $winPath + '\.claude[/\\]scripts[/\\]' + $subPath + '+["'']?(?:\s+.*)?$'),
    ($cdPrefix + 'node\s+' + $winPath + 'web[/\\]' + $subPath + '+["'']?(?:\s+.*)?$'),
    ($cdPrefix + 'node\s+' + $winPath + 'generated-docs[/\\]' + $subPath + '+["'']?(?:\s+.*)?$'),
    ($cdPrefix + 'node\s+' + $winPath + '\.github[/\\]scripts[/\\]' + $subPath + '+["'']?(?:\s+.*)?$'),

    # --- Directory operations ---
    ($cdPrefix + 'mkdir\s+(?:-p\s+)?' + $winPath + 'generated-docs[/\\]?' + $subPath + '*["'']?\s*$'),

    # --- File reading (safe directories only) ---
    ($cdPrefix + 'sed\s+-n\s+.+\s+' + $winPath + '(documentation|web|\.claude|\.github|generated-docs)[/\\]' + $subPath + '+["'']?\s*$'),
    ($cdPrefix + 'cat\s+' + $winPath + '(documentation|web|generated-docs|\.claude|\.github)[/\\]' + $subPath + '+["'']?\s*$'),
    # Node modules type definitions (read-only, allows fallback with || and pipe to head)
    ($cdPrefix + 'cat\s+node_modules/[\w@./-]+\.d\.ts(?:\s+2>/dev/null)?(?:\s+\|\|\s+cat\s+node_modules/[\w@.*/-]+\.d\.ts)?(?:\s+\|\s+head\s+-?\d+)?\s*$'),
    ($cdPrefix + 'type\s+' + $winPath + '(documentation|web|generated-docs|\.claude|\.github)[/\\]' + $subPath + '+["'']?\s*$'),
    ($cdPrefix + 'cat\s+' + $winPath + '[\w.-]+\.config\.[\w]+["'']?\s*$'),
    ($cdPrefix + 'type\s+' + $winPath + '[\w.-]+\.config\.[\w]+["'']?\s*$'),

    # --- File writing (safe directories only) ---
    ($cdPrefix + 'cat\s*>\s*' + $winPath + '(\.claude[/\\]context|generated-docs)[/\\]' + $subPath + '+["'']?\s*$'),
    # Heredoc writes to safe directories (cat > file << 'EOF' - no $ anchor because heredoc body follows)
    ($cdPrefix + 'cat\s*>\s*' + $winPath + '(\.claude[/\\]context|generated-docs)[/\\]' + $subPath + '+["'']?\s*<<\s*-?\s*[''"]?\w+[''"]?'),

    # --- Directory listing (allows globs like *.ts and 2>&1 redirect) ---
    ($cdPrefix + 'ls(?:\s+-[\w]+)*(?:\s+["'']?[\w./:~\\*?-]+["'']?)*(?:\s+2>&1)?\s*$'),
    # Safe directory listing with any error handling suffix (absolute or relative paths, any slash style)
    ($cdPrefix + 'ls(?:\s+-[\w]+)*\s+["'']?[\w./:~\\-]*(documentation|\.claude|generated-docs|web)[/\\]?' + $subPath + '*["'']?(?:\s+.*)?$'),
    ($cdPrefix + 'dir(?:\s+' + $winPath + '["'']?)*\s*$'),
    ($cdPrefix + 'Get-ChildItem(?:\s+.*)?$'),

    # --- PowerShell (safe directories only) ---
    ('powershell\s+-Command\s+.*(Get-Content|Select-Object).*' + $winPath + '(documentation|web|\.claude|\.github|generated-docs)'),
    ('powershell\s+-Command\s+.*Set-Content.*' + $winPath + '(\.claude.context|generated-docs)'),

    # --- Utility commands ---
    ($cdPrefix + 'which\s+\w+'),
    ($cdPrefix + 'where\.exe\s+\w+'),
    ($cdPrefix + 'command\s+-v\s+\w+'),
    ($cdPrefix + 'node\s+--version\s*$'),
    ($cdPrefix + 'npm\s+--version\s*$'),
    ($cdPrefix + 'git\s+--version\s*$'),
    # Read-only git commands
    ($cdPrefix + 'git\s+status(?:\s+.*)?$'),
    ($cdPrefix + 'git\s+log(?:\s+.*)?$'),
    ($cdPrefix + 'git\s+diff(?:\s+.*)?$'),
    ($cdPrefix + 'git\s+show(?:\s+.*)?$'),
    ($cdPrefix + 'git\s+branch(?:\s+(?:-[avrl]+|--(?:list|all|remotes|contains|merged|no-merged)))*\s*$'),
    ($cdPrefix + 'git\s+rev-parse(?:\s+.*)?$'),
    ($cdPrefix + 'git\s+remote(?:\s+-v)?\s*$'),
    ($cdPrefix + 'git\s+stash\s+list(?:\s+.*)?$'),
    ($cdPrefix + 'git\s+describe(?:\s+.*)?$'),
    ($cdPrefix + 'git\s+tag(?:\s+(?:-l|--list)(?:\s+.*)?)?$'),
    ($cdPrefix + 'pwd\s*$'),
    ($cdPrefix + 'echo\s+\$[\w]+\s*$'),

    # --- Standalone commands (for compound command splitting) ---
    # cd to any directory (standalone, not as prefix)
    'cd\s+["'']?[\w./:~\\-]+["'']?\s*$',
    # echo with quoted string or simple word
    'echo\s+["''].*["'']\s*$',
    'echo\s+[\w./:~\\-]+\s*$',
    # Temp file heredoc writes (for TDD test file creation)
    ('cat\s*>\s*["'']?/tmp/' + $subPath + '+["'']?\s*<<\s*-?\s*[''"]?\w+[''"]?'),
    # Temp file reads
    ('cat\s+["'']?/tmp/' + $subPath + '+["'']?\s*$'),
    # File/directory existence checks (all test flags are read-only)
    '(?:test\s+-[defrsxw]|\[\s+-[defrsxw])\s+["'']?[\w./:~\\-]+["'']?\s*\]?\s*$',
    # Boolean commands (used in conditional chains)
    'true\s*$',
    'false\s*$'
)

# Check if command matches any allow pattern
foreach ($pattern in $allowPatterns) {
    if ($command -imatch "^$pattern") {
        $output = @{
            hookSpecificOutput = @{
                hookEventName = "PreToolUse"
                permissionDecision = "allow"
                permissionDecisionReason = "Auto-approved: matches safe command pattern"
            }
        } | ConvertTo-Json -Depth 10 -Compress

        Write-Output $output
        exit 0
    }
}

# =============================================================================
# COMPOUND COMMAND SPLITTING - second pass for multi-command strings
# =============================================================================
# If the whole command didn't match any single pattern, try splitting on
# &&, ||, ;, and newlines, then check each sub-command individually.

# Helper: check if a single sub-command is allowed (with recursive paren-stripping)
function Test-SubCommandAllowed {
    param([string]$SubCmd)

    # Check against deny patterns first
    foreach ($pattern in $denyPatterns) {
        if ($SubCmd -imatch $pattern) {
            [Console]::Error.WriteLine("Blocked by security policy: Sub-command matches deny pattern")
            exit 2
        }
    }

    # Check against allow patterns
    foreach ($pattern in $allowPatterns) {
        if ($SubCmd -imatch "^$pattern") {
            return $true
        }
    }

    # If wrapped in parentheses, strip and recursively check inner content
    $stripped = $SubCmd
    while ($stripped -match '^\s*\((.+)\)\s*$') {
        $stripped = $Matches[1].Trim()
    }
    if ($stripped -ne $SubCmd) {
        # Try splitting the inner content into sub-commands first
        # (splitting before single-pattern match avoids loose .* patterns
        # swallowing && operators as "arguments")
        $innerCommands = Split-CompoundCommand -CommandText $stripped
        if ($null -ne $innerCommands -and $innerCommands.Count -gt 1) {
            foreach ($inner in $innerCommands) {
                if (-not (Test-SubCommandAllowed -SubCmd $inner)) {
                    return $false
                }
            }
            return $true
        }
        # If not splittable, try matching as a single command
        foreach ($pattern in $allowPatterns) {
            if ($stripped -imatch "^$pattern") {
                return $true
            }
        }
    }

    return $false
}

$subCommands = Split-CompoundCommand -CommandText $command

if ($null -ne $subCommands -and $subCommands.Count -gt 1) {
    $allAllowed = $true
    foreach ($subCmd in $subCommands) {
        if (-not (Test-SubCommandAllowed -SubCmd $subCmd)) {
            $allAllowed = $false
            break
        }
    }

    if ($allAllowed) {
        $output = @{
            hookSpecificOutput = @{
                hookEventName = "PreToolUse"
                permissionDecision = "allow"
                permissionDecisionReason = "Auto-approved: all sub-commands match safe patterns"
            }
        } | ConvertTo-Json -Depth 10 -Compress

        Write-Output $output
        exit 0
    }
}

# Third pass: if the whole command is wrapped in parentheses, try stripping and re-checking
if ($command -match '^\s*\(') {
    if (Test-SubCommandAllowed -SubCmd $command) {
        $output = @{
            hookSpecificOutput = @{
                hookEventName = "PreToolUse"
                permissionDecision = "allow"
                permissionDecisionReason = "Auto-approved: parenthesized command contains safe sub-commands"
            }
        } | ConvertTo-Json -Depth 10 -Compress

        Write-Output $output
        exit 0
    }
}

# No match - fall through to normal permission system
exit 0
