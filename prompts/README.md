# Bjarne Prompts Directory

This directory contains all AI prompt templates used by the Bjarne autonomous development system. Prompts are separated from the main script logic for easier maintenance and independent editing.

## Directory Structure

```
prompts/
├── plan.md                    # Main planning phase prompt
├── execute.md                 # Code execution phase prompt
├── review.md                  # Review and validation prompt
├── fix.md                     # Error fixing prompt
├── init.md                    # Project initialization prompt
├── refresh.md                 # Context refresh prompt
├── decompose.md               # Task decomposition prompt
├── finalize-worktree.md       # Finalization with git worktree support
├── finalize.md                # Standard finalization prompt
├── batch-plan.md.template     # Batch mode planning (requires $BJN_BATCH_SIZE)
├── batch-execute.md           # Batch mode execution
├── batch-review.md            # Batch mode review
├── batch-fix.md               # Batch mode fixing
├── dockerfile.template        # Dockerfile generation (requires $BJN_base_image)
└── verbose-rules.template     # Verbose output rules (requires $BJN_BJARNE_TMP_DIR)
```

## File Types

### Static Prompts (*.md)
Static prompts are loaded as-is without any modification. Use this format for prompts that don't require dynamic content.

**Examples:** `plan.md`, `execute.md`, `review.md`, `fix.md`

### Template Files (*.template)
Template files contain variable placeholders that get substituted at runtime. Variables use the `$VAR_NAME` format and are replaced using `envsubst`.

**Examples:** `batch-plan.md.template`, `dockerfile.template`, `verbose-rules.template`

## Prompt Files Reference

### Main Loop Prompts

| File | Purpose | When Used | Variables |
|------|---------|-----------|-----------|
| `plan.md` | Planning phase prompt | First step of each iteration | None |
| `execute.md` | Code execution prompt | Second step - implementation | None |
| `review.md` | Review and validation | Third step - verification | None |
| `fix.md` | Error fixing prompt | Fourth step (if errors found) | None |

### Initialization Prompts

| File | Purpose | When Used | Variables |
|------|---------|-----------|-----------|
| `init.md` | Project initialization | `bjarne init` command | None |
| `refresh.md` | Context refresh | `bjarne refresh` command | None |

### Task Mode Prompts

| File | Purpose | When Used | Variables |
|------|---------|-----------|-----------|
| `decompose.md` | Task decomposition | Breaking down complex tasks | None |
| `finalize-worktree.md` | Worktree finalization | Task completion with git worktree | `$WORKTREE_BRANCH` |
| `finalize.md` | Standard finalization | Task completion without worktree | None |

### Batch Mode Prompts

| File | Purpose | When Used | Variables |
|------|---------|-----------|-----------|
| `batch-plan.md.template` | Batch planning | First step in batch mode | `$BJN_BATCH_SIZE` |
| `batch-execute.md` | Batch execution | Second step in batch mode | None |
| `batch-review.md` | Batch review | Third step in batch mode | None |
| `batch-fix.md` | Batch fixing | Fourth step in batch mode | None |

### Utility Templates

| File | Purpose | When Used | Variables |
|------|---------|-----------|-----------|
| `dockerfile.template` | Docker environment setup | Safe mode container creation | `$BJN_base_image` |
| `verbose-rules.template` | Verbose output rules | Debug mode | `$BJN_BJARNE_TMP_DIR` |

## Usage Guidelines

### Loading Prompts in the Script

The script provides two functions for loading prompts:

#### 1. `load_prompt()` - For Static Prompts
```bash
# Load a static prompt file
PLAN_PROMPT=$(load_prompt "plan.md")

# The function handles both relative and absolute paths
# Relative paths are resolved from $PROMPTS_DIR
```

#### 2. `load_prompt_with_subst()` - For Template Files
```bash
# Load template with specific variable substitution
DOCKERFILE=$(load_prompt_with_subst "dockerfile.template" '$BJN_base_image')

# Load template with all environment variables
FULL_CONTENT=$(load_prompt_with_subst "batch-plan.md.template")

# Always specify only the variables you need for security
```

### Adding New Prompts

1. **Choose the right file type:**
   - Use `.md` for static content
   - Use `.template` for content with variables

2. **Create the file:**
   ```bash
   # Static prompt
   echo "Your prompt content here" > prompts/new-feature.md

   # Template with variable
   echo "Process $TARGET_FILE with options $OPTIONS" > prompts/process.template
   ```

3. **Load it in the script:**
   ```bash
   # Static
   NEW_PROMPT=$(load_prompt "new-feature.md")

   # Template
   PROCCESS_PROMPT=$(load_prompt_with_subst "process.template" '$TARGET_FILE $OPTIONS')
   ```

4. **Document it:** Add an entry to this README with purpose, usage, and required variables.

## Variable Substitution

Template files use `envsubst` for variable substitution. This provides safety by only substituting variables you explicitly specify.

**Best Practices:**
- Always specify the exact variables to substitute: `load_prompt_with_subst "file.template" '$var1 $var2'`
- Use single quotes for variable names to prevent shell expansion
- Document all required variables in this README
- Use descriptive variable names that match their purpose

## File Naming Conventions

- Use lowercase letters and hyphens: `batch-plan.md`, `dockerfile.template`
- Add `.template` suffix for files requiring variable substitution
- Keep names descriptive but concise
- Group related files with common prefixes: `batch-*.md`

## Testing Changes

After modifying prompts:

1. **Syntax check:** `bash -n AutoCode/bjarne`
2. **Test affected commands:**
   - Modified init prompts? Test `bjarne init`
   - Modified batch prompts? Test `bjarne --batch`
   - Modified task prompts? Test `bjarne task`
3. **Verify variable substitution** for templates
4. **Check for unintended side effects** in other modes

## Maintenance Tips

- Keep prompts focused on their specific phase/purpose
- Maintain consistency in tone and style across prompts
- Use clear, concise instructions
- Update this README when adding or modifying prompts
- Test changes in isolation before committing

## Related Files

- Main script: `AutoCode/bjarne`
- Loading functions: Lines 304-365 in bjarne script
- Prompt usage: Search for `load_prompt` and `load_prompt_with_subst` in bjarne script
