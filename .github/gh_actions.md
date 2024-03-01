# How CI works

The idea is to have an easy to use pattern that can be used locally and in GitHub Actions similar to [How CI works at GitHub and locally](https://github.com/github/scripts-to-rule-them-all)

- `.github/scripts` contains bash scripts responsible for a unit of work.

- `.github/Taskfile.yml` contains tasks that run the scripts.

- `workflows/ci.yml` contains the GitHub Actions workflow

---

## What is used in this project

1. [GitHub Super Linter](https://github.com/github/super-linter/blob/main/docs/run-linter-locally.md)

2. [Checkov](https://www.checkov.io/)

3. [Trivy](https://github.com/aquasecurity/trivy)

---

## Accessing the GitHub Actions tasks

`In your project root folder:`

Update your `Taskfile.yml` to use the GitHub Actions tasks:

```yaml
# Include the github actions tasks
includes:
  run: .github/Taskfile.yml
```

Create a task to run the GitHub Actions tasks:

```yaml
test:
  desc: "Run static tests"
  cmds:
    - task: run:lint
    - task: run:trivy
    - task: run:checkov
    - task: run:diff
```

---

## Commit code only if all tests pass

Create a [git hook](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) to verify tests are running before commiting:

> Git hooks are local to your machine and are not committed to the repository.

```bash
# Open the hooks directory for this repository
code .git/hooks
```

```bash
# Rename the pre-commit.sample file to pre-commit
mv .git/hooks/pre-commit.sample .git/hooks/pre-commit

# Make it executable
chmod +x .git/hooks/pre-commit
```

Add the following to the `.git/hooks/pre-commit` file:

```bash
#!/bin/sh

# Run task command and exit
task test

# If task test fails then exit with 1
if [ $? -ne 0 ]; then
 echo
 echo "Tests must pass before commit!"
 echo
 exit 1
fi
```

Verify the hook is working:

```bash
git commit -m "test commit"
```

If the tests fail you should see the following:

```shell
task: Failed to run task "test": exit status 1

Tests must pass before commit!
```

---

### Test the GitHub Actions tasks locally

```bash
# Run a job that needs access to gh token
act -j scan -s GITHUB_TOKEN="$(gh auth token)"

# Run a job using a local env file
act -j test --var-file .env

# Run a job using a local .secrets file
act -j test  --secret-file .secrets
```
