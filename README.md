# Z-BlogPHP App Pack Action

一个用于将 Z-BlogPHP 应用（插件或主题）打包为 `.zba` 安装包的 GitHub Action。

支持自动解析应用元数据（ID、名称、版本、修改时间等），并输出给后续工作流步骤使用（如自动创建 GitHub Release 并上传附件）。

---

## 特性

- 🚀 **开箱即用**：基于 Composite Action 与 PHP CLI，无需额外配置复杂容器。
- 📦 **自动元数据提取**：自动解析 `plugin.xml` 或 `theme.xml` 中的 ID、版本号、应用名及修改日期。
- 🗜️ **内置压缩与过滤**：支持 Gzip 压缩，自动忽略 `.git`、`.github`、`.gitignore` 及自定义 `zbignore.txt` 规则。
- 🔗 **完美衔接 CI/CD**：提供详细的 Outputs，方便配合 `softprops/action-gh-release` 等工具一键发布 Release。

---

## 输入参数 (Inputs)

| 参数 | 必填 | 默认值 | 说明 |
| :--- | :--- | :--- | :--- |
| `path` | 否 | `.` | 待打包的应用目录路径（必须包含 `plugin.xml` 或 `theme.xml`） |
| `output` | 否 | 自动生成 | 指定输出的 `.zba` 完整路径（默认格式为 `<appId>_<version>_<modified>.zba`） |
| `gzip` | 否 | `true` | 是否使用 Gzip 压缩生成 `.zba`（可选 `true` / `false`） |
| `verbose` | 否 | `false` | 是否在控制台打印详细的打包文件明细（可选 `true` / `false`） |

---

## 输出参数 (Outputs)

| 输出项 | 说明 | 示例 |
| :--- | :--- | :--- |
| `zba-path` | 生成的 `.zba` 文件绝对路径 | `/home/runner/work/.../live2d2_1.0.1_20230624.zba` |
| `zba-name` | 生成的 `.zba` 文件名 | `live2d2_1.0.1_20230624.zba` |
| `app-id` | 应用 ID | `live2d2` |
| `app-name` | 应用显示名称 | `看板娘-伊斯特瓦尔` |
| `app-version` | 应用版本号 | `1.0.1` |
| `app-type` | 应用类型 | `plugin` 或 `theme` |
| `app-modified`| 应用修改日期 | `2023-06-24` |

---

## 使用示例

### 示例 1：推送 Tag 时自动打包并创建 GitHub Release

在应用仓库根目录下创建 `.github/workflows/release.yml`：

```yaml
name: Build & Release ZBA

on:
  push:
    tags:
      - 'v*'
  workflow_dispatch:

jobs:
  build-and-release:
    runs-on: ubuntu-latest
    permissions:
      contents: write

    steps:
      - name: Checkout Code
        uses: actions/checkout@v5

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'

      - name: Pack ZBA
        id: pack
        uses: wdssmq/zbp-app-pack@v1
        with:
          path: '.'

      - name: Create GitHub Release
        uses: softprops/action-gh-release@v2
        with:
          files: ${{ steps.pack.outputs.zba-path }}
          name: ${{ steps.pack.outputs.app-name }} v${{ steps.pack.outputs.app-version }}
          tag_name: ${{ github.ref_name }}
          draft: false
          prerelease: false
          generate_release_notes: true
          body: |
            ### 📦 应用信息
            - **应用 ID**：`${{ steps.pack.outputs.app-id }}`
            - **应用类型**：`${{ steps.pack.outputs.app-type }}`
            - **版本号**：`${{ steps.pack.outputs.app-version }}`
            - **最后修改**：`${{ steps.pack.outputs.app-modified }}`
            - **安装包**：`${{ steps.pack.outputs.zba-name }}`

```

---

## 自定义忽略规则

在应用根目录下创建 `zbignore.txt`，添加不需要打包进 `.zba` 的文件或目录（支持通配符），例如：

```plaintext
node_modules
tests
*.log
.prettierrc

```

---

## 开源协议

[MIT License](LICENSE)
