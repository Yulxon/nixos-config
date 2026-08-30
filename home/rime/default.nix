# Rime（中州韵）用户配置 —— 由 home-manager 声明式托管。
#
# 共享数据（rime-ice 方案/词库、zhwiki、moegirl）由系统层 modules/gui.nix 提供：
#   i18n.inputMethod.ibus.engines = [
#     (rime.override { rimeDataPkgs = [ rime-ice rime-zhwiki rime-moegirl ]; })
#   ]
# 这里的 rimeDataPkgs 更新会随 `nix flake update nixpkgs` 一起进行。
#
# 本模块只负责 ~/.config/ibus/rime 下的“用户文件”：
#   - default.custom.yaml     方案列表、候选页大小（继承 rime-ice 的 default.yaml）
#   - rime_ice.custom.yaml    万象语法模型（大模型候选）+ 挂载扩展字库
#   - rocom_mixed.dict.yaml   本地维护词库（洛克王国）
#   - wanxiang-lts-zh-hans.gram  万象语法模型文件（约 420MB，nix store 软链接）
#
# 注意：rime 的 *.userdb、build/、installation.yaml、user.yaml 等运行期状态
# 不受托管，保留在用户目录中。
{ pkgs, ... }:
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

    # 万象语法模型（大模型候选）+ 挂载扩展字库。
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

        # 扩展字库：
        #   zhwiki  （中文维基百科） 来自 nixpkgs rime-zhwiki
        #   moegirl （萌娘百科）     来自 nixpkgs rime-moegirl
        #   rocom_mixed（洛克王国）  本地维护（本模块内的文件）
        # zhwiki/moegirl 的 .dict.yaml 位于合并后的 rime-data 顶层，直接引用表名即可。
        import_tables/+:
          - zhwiki
          - moegirl
          - rocom_mixed
    '';

    # 洛克王国词库（本地维护，随仓库版本化）
    ".config/ibus/rime/rocom_mixed.dict.yaml".source = ./rocom_mixed.dict.yaml;

    # 万象语法模型文件（约 420MB，软链接到 nix store，不占用 home 磁盘）。
    # 上游用同一个 LTS URL 原地覆盖更新（不可复现），nixpkgs 的 rime-wanxiang 包
    # 也因此明确不打包该文件。因此这里固定 hash：上游更新后 nix 构建会失败，
    # 届时用 `nix-prefetch-url <url>` 拿到新 hash 更新即可（见 README.md）。
    ".config/ibus/rime/wanxiang-lts-zh-hans.gram".source = pkgs.fetchurl {
      url = "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram";
      sha256 = "sha256-YKqCBEHCuAZmmWYulFIYviGfUVdIVjReS+opYrf/FMo=";
    };
  };
}
