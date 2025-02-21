#!/bin/bash

# Make sure the hooks directory exists
mkdir -p .git/hooks

# Create symlink for pre-commit hook
ln -sf ../../hooks/pre-commit .git/hooks/pre-commit

# Make the hooks executable
chmod +x hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo "Git hooks installed successfully!" 