# Rime 输入法（home-manager 托管）

雾凇拼音（rime-ice）输入方案，扩展字库 moegirl / zhwiki，以及万象（Wanxiang）大模型语法候选。
数据与配置全部声明式托管：**nix 管包、home-manager 管用户配置**。

## 架构

| 层 | 位置 | 内容 |
|----|------|------|
| 系统（NixOS） | `modules/gui.nix` 的 `i18n.inputMethod` | ibus-rime + `rimeDataPkgs = [ rime-ice rime-zhwiki rime-moegirl ]`，合并后的数据位于 ibus-rime 的 `share/rime-data` |
| 用户（home-manager） | `home/rime/default.nix` | `~/.config/ibus/rime/` 下的用户文件：两个 `*.custom.yaml`、`rocom_mixed.dict.yaml`、`wanxiang-lts-zh-hans.gram` |

`~/.config/ibus/rime` 中的 `build/`、`*.userdb/`、`installation.yaml`、`user.yaml` 是运行期状态，**不受托管**，保留在用户目录。

## 更新

```bash
# 1. 更新数据包（rime-ice / rime-zhwiki / rime-moegirl 随 nixpkgs 更新）
cd ~/Projects/nixos-config
nix flake update nixpkgs
sudo nixos-rebuild switch --flake .#asus

# 2. 重新部署 Rime（在输入法设置里“重新部署”，或注销重登）
```

## 万象语法模型（wanxiang-lts-zh-hans.gram）

约 420MB，来自 <https://github.com/amzxyz/RIME-LMDG/releases/tag/LTS>。
上游用同一个 `LTS` release URL **原地覆盖更新**（不可复现），因此 nixpkgs 的
`rime-wanxiang` 包也明确不打包该文件（见其 longDescription）。

本仓库做法：`home/rime/default.nix` 中用 `pkgs.fetchurl` 固定 hash 拉取，
软链接到 `~/.config/ibus/rime/`。

- 上游更新模型后，`nixos-rebuild` 会因 hash 不匹配而**显式失败**（不会静默用旧文件）。
- 更新 hash：

```bash
nix-prefetch-url https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram
# 把输出填进 home/rime/default.nix 的 sha256
```

## 词库

- `zhwiki`（中文维基百科）→ nixpkgs `rime-zhwiki`，随 `nix flake update` 更新
- `moegirl`（萌娘百科）→ nixpkgs `rime-moegirl`，随 `nix flake update` 更新
- `rocom_mixed`（洛克王国）→ 仓库内 `home/rime/rocom_mixed.dict.yaml`，本地维护

三者都在 `rime_ice.custom.yaml` 的 `import_tables/+` 中挂载。

## 万象候选（大模型）

`rime_ice.custom.yaml` 中的 `grammar:` 配置（与 rime-ice 上游
`others/recipes/grammar.recipe.yaml` 一致）启用万象语法模型：
输入时 librime（含 librime-octagram 模块）会根据整句上下文给出
LLM 风格的候选排序（collocation 搭配模型）。

- 需要 librime 带 octagram 模块：nixpkgs 的 `librime` 默认启用
  `plugins = [ librime-lua librime-octagram ]`（见 `pkgs/by-name/li/librime`）。
- librime-lua 对 `lua_processor@*xxx` 等 `*` 前缀组件会直接从 `lua/` 目录
  `require` 自动加载，因此新版本 rime-ice 不再需要 `rime.lua`（旧版手动复制
  的 `rime.lua` 已从用户目录清理）。
