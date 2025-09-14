#!/usr/bin/env bash
set -euo pipefail

# agent-rules 本地同步脚本（macOS / Linux）
# 仅覆盖同名文件；不删除本地多余文件。
# 备份到 ~/.agent-rules-backup/<agent>/...，并在备份文件名追加 _YYYYMMDD_HHMMSS_backup 后缀。

REPO_OWNER=${REPO_OWNER:-"jeejeeguan"}
REPO_NAME=${REPO_NAME:-"agent-rules"}
BRANCH=${1:-${BRANCH:-"main"}}

COLOR_BLUE='\033[34m'
COLOR_GREEN='\033[32m'
COLOR_YELLOW='\033[33m'
COLOR_RESET='\033[0m'

timestamp() { date '+%Y%m%d_%H%M%S'; }

echo -e "${COLOR_BLUE}📦 同步分支:${COLOR_RESET} ${BRANCH}"
echo -e "${COLOR_BLUE}🔗 源仓库:${COLOR_RESET} https://github.com/${REPO_OWNER}/${REPO_NAME}"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "缺少依赖: $1" >&2; exit 2; }
}

need_cmd curl
need_cmd tar

TMPDIR=$(mktemp -d 2>/dev/null || mktemp -d -t agentrules)
cleanup() { rm -rf "$TMPDIR" >/dev/null 2>&1 || true; }
trap cleanup EXIT

TARBALL_URL="https://codeload.github.com/${REPO_OWNER}/${REPO_NAME}/tar.gz/refs/heads/${BRANCH}"
TARBALL="${TMPDIR}/src.tar.gz"

echo -e "${COLOR_BLUE}⬇️  下载:${COLOR_RESET} ${TARBALL_URL}"
curl -fsSL "$TARBALL_URL" -o "$TARBALL"

echo -e "${COLOR_BLUE}📂 解压中...${COLOR_RESET}"
tar -xzf "$TARBALL" -C "$TMPDIR"

# 找到解压后的根目录（形如 repo-<sha>）
SRC_DIR=$(find "$TMPDIR" -mindepth 1 -maxdepth 1 -type d -name "${REPO_NAME}-*" | head -n1)
if [ -z "${SRC_DIR}" ]; then
  echo "未找到解压目录" >&2
  exit 3
fi

AGENTS=(claude codex gemini)
HOME_DIR=${HOME}
BACKUP_ROOT="${HOME_DIR}/.agent-rules-backup"
TS=$(timestamp)

changed_total=0
skipped_total=0

for agent in "${AGENTS[@]}"; do
  local_dir="${HOME_DIR}/.${agent}"
  remote_dir="${SRC_DIR}/.${agent}"

  if [ ! -d "$local_dir" ]; then
    echo -e "${COLOR_YELLOW}⚠️  跳过: ~/${agent} 不存在${COLOR_RESET}"
    continue
  fi

  if [ ! -d "$remote_dir" ]; then
    echo -e "${COLOR_YELLOW}⚠️  跳过: 远端不含 .${agent}/ 目录${COLOR_RESET}"
    continue
  fi

  echo -e "${COLOR_BLUE}🔄 同步 .${agent}/ → ~/.${agent}/（仅覆盖同名文件）${COLOR_RESET}"

  while IFS= read -r -d '' f; do
    rel_path=${f#"${remote_dir}/"}
    dst_path="${local_dir}/${rel_path}"

    if [ -f "$dst_path" ]; then
      mkdir -p "${BACKUP_ROOT}/${agent}/$(dirname "$rel_path")"
      base_name=$(basename "$dst_path")
      backup_path="${BACKUP_ROOT}/${agent}/$(dirname "$rel_path")/${base_name}_${TS}_backup"
      cp -p "$dst_path" "$backup_path"

      mkdir -p "$(dirname "$dst_path")"
      cp -p "$f" "$dst_path"
      echo -e "${COLOR_GREEN}✓ 覆盖:${COLOR_RESET} ~/.${agent}/${rel_path}  （备份→ ${backup_path})"
      changed_total=$((changed_total+1))
    else
      echo -e "${COLOR_YELLOW}↷ 跳过新文件:${COLOR_RESET} ~/.${agent}/${rel_path}（本地不存在同名文件）"
      skipped_total=$((skipped_total+1))
    fi
  done < <(find "$remote_dir" -type f -print0)
done

echo
echo -e "${COLOR_GREEN}✅ 完成${COLOR_RESET} 覆盖: ${changed_total}，跳过: ${skipped_total}"
echo -e "备份目录: ${BACKUP_ROOT}"

