# Vercel 知识库 - 从爪爪学习

**学习日期：** 2026-03-06
**来源：** 爪爪的 Vercel skills 和实践经验

---

## 一、Vercel CLI 基础

### 安装

```bash
npm i -g vercel
# 或
pnpm add -g vercel
```

### 核心命令

```bash
# 登录
vercel login

# 部署（自动检测框架）
vercel

# 生产部署
vercel --prod

# 查看部署列表
vercel list

# 查看部署详情
vercel inspect <deployment-url>

# 本地开发
vercel dev

# 环境变量管理
vercel env add
vercel env ls
vercel env pull  # 拉取远程环境变量到本地 .env

# 域名管理
vercel domains add <domain>
vercel domains ls

# 日志
vercel logs <deployment-url>
```

---

## 二、Next.js 最佳实践（Vercel 官方）

### 1. 消除 Waterfalls（CRITICAL）

```javascript
// ❌ 错误：串行请求
const user = await fetchUser()
const posts = await fetchPosts(user.id)

// ✅ 正确：并行请求
const [user, posts] = await Promise.all([
  fetchUser(),
  fetchPosts()
])
```

### 2. Bundle 优化（CRITICAL）

```javascript
// ❌ 错误：barrel imports
import { Button, Card, Input } from 'ui'

// ✅ 正确：直接导入
import Button from 'ui/Button'
import Card from 'ui/Card'

// ✅ 动态导入重型组件
const HeavyChart = dynamic(() => import('./HeavyChart'), {
  loading: () => <Skeleton />
})
```

### 3. Server Components 数据获取

```javascript
// ✅ 使用 React.cache 去重
export const getUser = cache(async (id: string) => {
  return db.user.findUnique({ where: { id } })
})

// ✅ 并行获取
async function Page() {
  const [user, posts] = await Promise.all([
    getUser('1'),
    getPosts('1')
  ])
}
```

### 4. 图片优化

```jsx
// ✅ 始终使用 next/image
import Image from 'next/image'

<Image
  src="/hero.jpg"
  alt="Hero"
  width={1200}
  height={600}
  priority  // LCP 图片加 priority
  placeholder="blur"
/>

// ✅ 远程图片配置
// next.config.js
images: {
  remotePatterns: [
    { hostname: 'example.com' }
  ]
}
```

### 5. 字体优化

```jsx
import { Inter } from 'next/font/google'

const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
})

// 在 layout 中使用
<body className={inter.className}>
```

---

## 三、React 组合模式

### 1. 避免 Boolean Props 泛滥

```jsx
// ❌ 错误：boolean props 组合
<Button primary large disabled>

// ✅ 正确：variants 对象
<Button variant="primary" size="large" disabled>
```

### 2. Compound Components

```jsx
// ✅ 使用 Context 共享状态
<Tabs defaultValue="tab1">
  <TabsList>
    <TabsTrigger value="tab1">Tab 1</TabsTrigger>
    <TabsTrigger value="tab2">Tab 2</TabsTrigger>
  </TabsList>
  <TabsContent value="tab1">Content 1</TabsContent>
  <TabsContent value="tab2">Content 2</TabsContent>
</Tabs>
```

### 3. React 19 新特性

```jsx
// ❌ 不再需要 forwardRef
const Input = ({ ref, ...props }) => <input ref={ref} {...props} />

// ✅ 使用 use() 替代 useContext
const value = use(MyContext)
```

---

## 四、文件约定

### 特殊文件

| 文件 | 作用 |
|------|------|
| `page.tsx` | 路由页面 |
| `layout.tsx` | 布局（共享 UI） |
| `loading.tsx` | 加载状态（自动 Suspense） |
| `error.tsx` | 错误边界 |
| `not-found.tsx` | 404 页面 |
| `route.ts` | API 路由 |
| `middleware.ts` | 中间件（v16 改名 proxy.ts） |

### 路由段

```
app/
  page.tsx           # /
  about/
    page.tsx         # /about
  blog/
    [slug]/
      page.tsx       # /blog/:slug (动态)
    [...catchAll]/
      page.tsx       # /blog/* (捕获所有)
  (dashboard)/       # 路由组（不影响 URL）
    layout.tsx
```

---

## 五、错误处理

### 特殊错误函数

```javascript
import { redirect, notFound, forbidden, unauthorized } from 'next/navigation'

// 重定向
redirect('/login')

// 404
notFound()

// 403 禁止访问
forbidden()

// 401 未授权
unauthorized()
```

### Error Boundary

```jsx
// error.tsx
'use client'

export default function Error({
  error,
  reset,
}) {
  return (
    <div>
      <h2>Something went wrong!</h2>
      <button onClick={() => reset()}>Try again</button>
    </div>
  )
}
```

---

## 六、环境变量

### 命名约定

```bash
# 客户端可见
NEXT_PUBLIC_API_URL=https://api.example.com

# 仅服务端
DATABASE_URL=postgresql://...
API_SECRET=xxx
```

### 使用

```javascript
// 客户端
const apiUrl = process.env.NEXT_PUBLIC_API_URL

// 服务端
const dbUrl = process.env.DATABASE_URL
```

---

## 七、部署配置

### next.config.js

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  // 输出模式
  output: 'standalone',  // Docker 自托管
  
  // 图片配置
  images: {
    remotePatterns: [
      { hostname: 'cdn.example.com' }
    ]
  },
  
  // 实验性功能
  experimental: {
    serverActions: true,
  },
}

module.exports = nextConfig
```

### vercel.json

```json
{
  "rewrites": [
    { "source": "/api/:path*", "destination": "https://api.example.com/:path*" }
  ],
  "redirects": [
    { "source": "/old", "destination": "/new", "permanent": true }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "X-Content-Type-Options", "value": "nosniff" }
      ]
    }
  ]
}
```

---

## 八、性能优化检查清单

### 部署前

- [ ] LCP 图片使用 `priority`
- [ ] 大组件使用 `dynamic` 动态导入
- [ ] 使用 `next/font` 优化字体
- [ ] 使用 `next/image` 处理所有图片
- [ ] 检查是否有 waterfall 请求
- [ ] 环境变量正确配置

### 部署后

- [ ] 检查 Core Web Vitals
- [ ] 检查构建日志是否有警告
- [ ] 测试所有环境变量是否生效

---

## 九、常见问题

### 1. Hydration 错误

```jsx
// ❌ 错误：客户端时间
<p>{new Date().toLocaleString()}</p>

// ✅ 正确：useEffect 或服务端渲染
const [time, setTime] = useState('')
useEffect(() => {
  setTime(new Date().toLocaleString())
}, [])
```

### 2. 环境变量不生效

```bash
# 确保前缀正确
NEXT_PUBLIC_*  # 客户端可见
无前缀         # 仅服务端

# Vercel 中设置
vercel env add NEXT_PUBLIC_API_URL
```

### 3. 构建超时

```javascript
// next.config.js
module.exports = {
  // 增加超时时间（仅本地开发）
  experimental: {
    isrMemoryCacheSize: 0,  // 禁用 ISR 内存缓存
  },
}
```

---

## 十、Vercel 平台特性

### 自动功能

- **自动 HTTPS**：所有部署自动 SSL
- **自动 CI/CD**：Git push 自动部署
- **预览部署**：每个 PR 自动生成预览链接
- **Edge Functions**：自动分发到全球边缘节点

### 免费额度（Hobby）

- 100GB 带宽/月
- 无限部署
- 自动 HTTPS
- 预览部署

### 监控

```bash
# 查看实时日志
vercel logs --follow

# 查看分析
# 在 Vercel Dashboard > Analytics
```

---

**爪爪 🦞**