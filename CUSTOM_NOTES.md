# Custom Notes

- 不直接在 main 分支开发
- 所有魔改优先放在 laogao / custom 维护分支
- 官方更新先同步上游，再合并到定制分支
- 每个功能尽量单独提交，方便以后排错
- 自定义更新按钮默认从 GitHub Release 下载 ipk
- 设备侧更新脚本建议放到 `/usr/share/passwall/passwall-custom-update.sh`
- 节点导出逻辑不要伪造逻辑节点（如 _urltest / _balancing / _shunt）
- 不支持反向导出的节点，必须明确标记 UNSUPPORTED
