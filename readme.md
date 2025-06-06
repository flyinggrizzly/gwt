# gwt

An opinionated `git worktree` manager. Makes the most frequent commands easier.

Automatically organizes worktrees in a sane default location: `~/worktrees/<repo>/<branch>`.

## Example

```zsh

# Can only be run in a git repository
% cd ~/src/my-project

# Create a new branch and worktree, and move to it
% gwt add -b my-branch --cd

% pwd   #=> $HOME/worktrees/my-project/my-branch

# Do work, forget where you're at and what other work you have ongoing

% gwt status -m
TYPE     BRANCH       PATH                                   STATE
main     main         $HOME/src/my-project                   clean
linked   my-branch    $HOME/worktrees/my-project/my-branch   dirty + unpushed

# Finish your work, merge it, time to clean up, go back to the main repo
% gwt rm .

```

## Command reference

### `gwt add <branch>` - create a worktree

**Aliases:** `gwt add`, `gwt a`

#### Options

- `-b` creates the branch if it does not exist
- `--cd` automatically moves to the worktree after creation
- `--path|-p` provide an explicit location for the worktree to be created, overriding the default
- `--dry-run` prefixes all destructive commands with `echo` so you can inspect the output before commiting

### `gwt cd [<branch>]` - move between worktrees

**Aliases:** `gwt cd`, `gwt co`

When called with `<branch>`, moves to that linked worktree. When called without an argument, moves to the primary/parent
worktree.

Includes the `co` alias since `gwt co` and `gwt cd` are notionally the same operation for existing worktrees.

#### Options

- `--dry-run` prefixes all destructive commands with `echo` so you can inspect the output before commiting

### `gwt remove <branch|path>` - remove a worktree

**Aliases:** `gwt remove`, `gwt rm`

Removes the worktree for the specified branch, or path. Has special handling for `gwt rm .` which will first `gwt cd` to
the main worktree, and then remove the worktree.

#### Options

- `--force|-f` override unpushed and dirty state checks and force deletion
- `--dry-run` prefixes all destructive commands with `echo` so you can inspect the output before commiting

### `gwt status` - view the state of the repo's worktrees

**Aliases:** `gwt status`, `gwt st`, `gwt s`

Prints all linked worktrees showing `BRANCH`, `PATH`, and `STATE`.

`STATE` will show `"clean"` if the branch/tree is clean and up to date with any remotes, and `"dirty"`/`"unpushed"`  if
the branch/worktree is dirty or has unpushed changes (only relevant if there is a remote).

#### Options

- `--with-main|-m` also prints the primary worktree in the output, and adds a new column `TYPE` with a value of `main` or `linked` to designate the type of worktree
- `--porcelain` removes the column headers to improve machine readability

### `gwt clean` - remove all linked worktrees

Removes all linked worktrees (excluding the main worktree). Useful for cleaning up after feature work is complete.

#### Options

- `--force|-f` override unpushed and dirty state checks and force deletion of all worktrees
- `--dry-run` prefixes all destructive commands with `echo` so you can inspect the output before commiting

## Glossary

- **primary/parent worktree:** the "main" location of the repo. This is identified by the worktree that includes a `.git/` directory, instead of a `.git` symlink that points to the main worktree's `.git/worktrees/<branch>`
- **linked worktree:** a "satellite" worktree, with the symlinked `.git`

