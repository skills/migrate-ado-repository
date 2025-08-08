#!/usr/bin/env python3
"""
Simple Python application for Azure DevOps to GitHub migration demo.
"""


def greet(name="World"):
    """Return a greeting message."""
    return f"Hello, {name}!"


def main():
    """Main function."""
    print(greet("Azure DevOps Migration Demo"))
    print("This application was created in an ADO repository.")
    print("It will be migrated to GitHub as part of the demo.")


if __name__ == "__main__":
    main()
