# 问题：bun 安装时代理超时

> 创建于 2026-03-03 | 来源：memory/2026-03-03.md

## 背景

在安装 Compound Memory Framework 时，使用 `bun x @every-env/compound-plugin install compound-engineering` 命令。

系统已运行 mihomo 代理（端口 7890），但 bun 安装脚本内部的 curl 请求超时。

## 症状

```
error: Failed to download
Failure when receiving data from the peer
```

bun 安装脚本内部的 curl 没有走代理，直接访问 GitHub/GitLab 导致超时。

## 排查过程

### 尝试 1：检查代理是否运行
- 思路：确认 mihomo 是否正常工作
- 结果：代理运行正常，端口 7890 监听中
- 教训：问题不在代理本身

### 尝试 2：设置环境变量
- 思路：bun 安装脚本内部的 curl 需要环境变量
- 结果：✅ 成功
- 教训：子进程不会自动继承代理设置

## 最终方案

```bash
export HTTP_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
bun x @every-env/compound-plugin install compound-engineering --to openclaw
```

**为什么有效**：
- bun 安装脚本内部调用 curl
- curl 会读取 `HTTP_PROXY` / `HTTPS_PROXY` 环境变量
- 需要在运行命令的 shell 中设置，不是在 mihomo 中设置

## 关键洞察

1. **代理环境变量作用域**：`HTTP_PROXY` 只对当前 shell 及其子进程生效
2. **bun 安装脚本**：内部是 shell 脚本，会调用 curl/wget
3. **新版本语法**：`bunx` 命令在新版 bun 中应使用 `bun x` 代替

## 可复用模式

这个问题可以推广到：
- 任何 CLI 工具安装脚本内的网络请求
- npm/yarn/pnpm 的安装命令
- GitHub raw 内容下载
- CI/CD 中需要代理的场景

## 相关

- 日志：`memory/2026-03-03.md`
- 标签：#代理 #bun #curl #环境变量 #网络超时