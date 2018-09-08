# shell-select-menu
在 Shell 脚本中实现选择菜单

部分代码参考 https://github.com/the0neWhoKnocks/shell-menu-select

## 用法
selectionMenu "instruction" menuItems(一维数组的名称) $defaultIndex(可选,默认值为0) $flagLoop(可选,默认值为false)

### Example:
```bash
langs=("简体中文" "繁體中文" "English" "日本語")
selectResult=$(selectionMenu "Select Language" langs 2 true)
```