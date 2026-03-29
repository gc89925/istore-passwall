# PassWall Custom Update

## 目标

让路由器里的“自定义更新”按钮更新的是老高的定制版 PassWall，而不是纯官方版。

## 当前约定

- GitHub 仓库：`gc89925/istore-passwall`
- 默认分支：`laogao`
- 默认下载基址：`https://github.com/gc89925/istore-passwall/releases/latest/download`

## 推荐发布物

建议在 GitHub Release 中上传这些文件：

- `manifest.json`
- `luci-app-passwall_all.ipk`
- 如后续拆分更多包，可继续扩展为多个 ipk

## 当前设备侧更新流程

LuCI 按钮调用：

1. 优先调用 `/usr/share/passwall/passwall-custom-update.sh`
2. 优先尝试下载 `manifest.json`
3. 如果 manifest 中存在 `packages` 列表，则按顺序下载安装这些 ipk
4. 如果 manifest 不存在或解析失败，则回退为单文件安装 `luci-app-passwall_all.ipk`
5. 返回日志给前端

如果设备里没有该脚本，则回退到 LuCI 控制器中的内置下载/安装逻辑。

## 后续增强计划

### 1. 多文件安装
- 支持一个 manifest 文件
- 支持主包 + 依赖包批量安装

### 2. 版本检查
- 先请求 latest release
- 对比当前版本
- 有新版本再下载安装

### 3. 回滚能力
- 安装前缓存旧包信息
- 安装失败时保留日志并提示手工回滚

### 4. 更稳的发布格式
推荐 release 附带：

- `manifest.json`
- `luci-app-passwall_all.ipk`
- `sha256sums`

仓库里已增加示例文件：
- `release-manifest.example.json`

GitHub Actions 也已调整为：
- 生成 `manifest.json`
- 生成统一别名 `luci-app-passwall_all.ipk`
- 一并上传到 release

manifest 示例：

```json
{
  "version": "26.3.6-laogao.1",
  "packages": [
    "luci-app-passwall_all.ipk"
  ]
}
```
