# Compound Mind 部分更新方案设计

## 问题

更新框架时，会覆盖用户自定义的内容。

---

## 解决方案

**用标记包裹 Compound Mind 部分，只更新标记内的内容。**

---

## 标记设计

### HEARTBEAT.md

```markdown
# HEARTBEAT.md

## 用户自己的检查项

（用户内容）

---

<!-- COMPOUND_MIND_START -->
## 框架健康检查

检查 Compound Mind 框架运行状态...

<!-- COMPOUND_MIND_END -->

---

## 其他检查项

（用户内容）
```

### AGENTS.md

```markdown
# AGENTS.md

## 用户自己的规则

（用户内容）

---

<!-- COMPOUND_MIND_RULES_START -->
## Compound Mind Rules

### Todo Handling
...

<!-- COMPOUND_MIND_RULES_END -->
```

---

## 实现逻辑

### install.sh

```bash
# HEARTBEAT.md
if [ -f "$WORKSPACE/HEARTBEAT.md" ]; then
  # 文件存在，检查是否有标记
  if ! grep -q "COMPOUND_MIND_START" "$WORKSPACE/HEARTBEAT.md"; then
    # 没有标记，追加
    cat >> "$WORKSPACE/HEARTBEAT.md" << 'EOF'

---

<!-- COMPOUND_MIND_START -->
## 框架健康检查
...
<!-- COMPOUND_MIND_END -->
EOF
  fi
else
  # 文件不存在，创建
  cp templates/HEARTBEAT.md.tmpl "$WORKSPACE/HEARTBEAT.md"
fi
```

### update.sh

```bash
# HEARTBEAT.md
if [ -f "$WORKSPACE/HEARTBEAT.md" ]; then
  # 删除旧的 Compound Mind 部分
  if grep -q "COMPOUND_MIND_START" "$WORKSPACE/HEARTBEAT.md"; then
    sed -i '/<!-- COMPOUND_MIND_START -->/,/<!-- COMPOUND_MIND_END -->/d' "$WORKSPACE/HEARTBEAT.md"
  fi

  # 追加新的 Compound Mind 部分
  cat >> "$WORKSPACE/HEARTBEAT.md" << 'EOF'

---

<!-- COMPOUND_MIND_START -->
## 框架健康检查
（新内容）
<!-- COMPOUND_MIND_END -->
EOF
fi
```

---

## 优点

| 优点 | 说明 |
|------|------|
| 不覆盖用户内容 | 只更新标记内的部分 |
| 可追溯 | 标记清晰标识框架部分 |
| 灵活 | 用户可以在标记外添加自己的内容 |

---

## 实现步骤

| 步骤 | 内容 | 状态 |
|------|------|------|
| 1 | 更新 `templates/HEARTBEAT.md.tmpl` 添加标记 | 待实现 |
| 2 | 更新 `install.sh` 添加 HEARTBEAT.md 处理 | 待实现 |
| 3 | 更新 `update.sh` 添加部分更新逻辑 | 待实现 |
| 4 | 更新 AGENTS.md 标记和更新逻辑 | 待实现 |
| 5 | 测试 | 待实现 |

---

## 风险

| 风险 | 缓解措施 |
|------|----------|
| 用户误删标记 | 检测标记不存在时重新添加 |
| sed 兼容性 | 使用标准 sed 命令 |

EOF