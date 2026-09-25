# Rime（中州韵）用户配置 —— 由 home-manager 声明式托管。
#
# 共享数据（rime-ice 方案/词库、zhwiki、moegirl）由系统层 modules/gui.nix 提供。
# 雾凇词库通过 `nix flake update rime-ice` 更新；其余数据包随 nixpkgs 更新。
#
# 本模块只负责 ~/.config/ibus/rime 下的“用户文件”：
#   - default.custom.yaml     方案列表、候选页大小（继承 rime-ice 的 default.yaml）
#   - rime_ice.custom.yaml    万象语法模型（大模型候选）
#   - rime_ice.dict.yaml      雾凇词典 + 大字表、扩展词库
#   - wanxiang-lts-zh-hans.gram  万象语法模型文件（约 420MB，nix store 软链接）
#
# 注意：rime 的 *.userdb、build/、installation.yaml、user.yaml 等运行期状态
# 不受托管，保留在用户目录中。
{ pkgs, flake, ... }:
{
  home.file = {
    # 方案列表 + 候选页大小。
    # `__include: rime_ice_suggestion:/` 继承 rime-ice 打包的 default.yaml
    # （nixpkgs 的 rime-ice 包将上游 default.yaml 改名为 rime_ice_suggestion.yaml）。
    ".config/ibus/rime/default.custom.yaml".text = ''
      patch:
        __include: rime_ice_suggestion:/

        schema_list:
          - schema: rime_ice               # 雾凇拼音（全拼）
        menu:
          page_size: 6  # 候选词个数
    '';

    # 万象语法模型（大模型候选）。
    # 语法模型参数与上游 rime-ice others/recipes/grammar.recipe.yaml 一致。
    ".config/ibus/rime/rime_ice.custom.yaml".text = ''
      # 万象语法模型（LLM 候选）：https://github.com/amzxyz/RIME-LMDG/releases/tag/LTS
      # 模型文件 wanxiang-lts-zh-hans.gram 由 home-manager 从上游拉取（见下方 fetchurl）
      patch:
        grammar:
          language: wanxiang-lts-zh-hans
          collocation_max_length: 6
          collocation_min_length: 3
          collocation_penalty: -14
          non_collocation_penalty: -6
          weak_collocation_penalty: -100
          rear_penalty: -20
        translator/contextual_suggestions: false
        translator/max_homophones: 8

    '';

    # import_tables 必须写在词典文件中，不能通过 schema 的 custom.yaml 补丁添加。
    # 基于与系统层相同的雾凇源码生成，保留上游词条和后续更新。
    ".config/ibus/rime/rime_ice.dict.yaml".source = pkgs.runCommandLocal "rime-ice-dict.yaml" { } ''
      awk '
        /^  # - cn_dicts\/41448/ { sub(/^  # -/, "  -") }
        { print }
        /^  - cn_dicts\/others/ {
          print "  - zhwiki"
          print "  - moegirl"
        }
      ' ${flake.inputs.rime-ice}/rime_ice.dict.yaml > "$out"
    '';

    # 万象语法模型文件（约 420MB，软链接到 nix store，不占用 home 磁盘）。
    # 上游用同一个 LTS URL 原地覆盖更新（不可复现），nixpkgs 的 rime-wanxiang 包
    # 也因此明确不打包该文件。因此这里固定 hash：上游更新后 nix 构建会失败，
    # 届时用 `nix-prefetch-url <url>` 拿到新 hash 更新即可（见 README.md）。
    ".config/ibus/rime/wanxiang-lts-zh-hans.gram".source = pkgs.fetchurl {
      url = "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram";
      sha256 = "sha256-aZ0EWhvpJqOf0M2j9w4VMyRUElnbOQ1wtb8BF3QuRFE=";
    };
  };
}
