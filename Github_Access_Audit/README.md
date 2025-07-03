# 🔐 GitHub Repository Access Auditor

This Bash script fetches all users who have access to a given GitHub repository, along with their associated roles/permissions.

---

## 📌 About

This script helps repository maintainers or organization admins identify all collaborators on a repository and view their access levels (e.g., `admin`, `push`, `pull`). It uses the GitHub REST API to retrieve collaborator data securely via Personal Access Tokens (PATs).

---

## ✅ Features

- Lists all collaborators for a specified GitHub repository  
- Shows each collaborator’s **username** and **role**  
- Supports authentication via GitHub **username** and **token**  
- Easy to integrate into audits or CI/CD automation scripts  

---

## ⚙️ Prerequisites

Ensure the following tools are installed on your system:

- `bash` shell  
- `curl`  
- `jq` (for parsing JSON output)  
- A GitHub **Personal Access Token (PAT)** with at least `repo` scope  

Install `jq` (if not already installed):

```bash
# Ubuntu/Debian
sudo apt install jq

# macOS (Homebrew)
brew install jq
```

---

## 🧩 Usage

Copy and run the following steps in your terminal:

```
Step 1: Set your GitHub credentials as environment variables

export username=your_github_username
export token=your_github_token

Step 2: Run the script with the repository owner and name as arguments

./list-users.sh <REPO_OWNER> <REPO_NAME>

```

---