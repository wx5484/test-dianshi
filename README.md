## 环境变量

| 变量                                | 说明                                         | 可选值                           | 默认值                                                                                                                     |
| ----------------------------------- | -------------------------------------------- | -------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| USERNAME                            | 站长账号           | 任意字符串                       | 无默认，必填字段                                                                                                                     |
| PASSWORD                            | 站长密码           | 任意字符串                       | 无默认，必填字段                                                                                                                     |
| SITE_BASE                           | 站点 url              |       形如 https://example.com                  | 空                                                                                                                     |
| NEXT_PUBLIC_SITE_NAME               | 站点名称                                     | 任意字符串                       | MoonTV                                                                                                                     |
| ANNOUNCEMENT                        | 站点公告                                     | 任意字符串                       | 本网站仅提供影视信息搜索服务，所有内容均来自第三方网站。本站不存储任何视频资源，不对任何内容的准确性、合法性、完整性负责。 |
| NEXT_PUBLIC_STORAGE_TYPE            | 播放记录/收藏的存储方式                      | redis、kvrocks、upstash | 无默认，必填字段                                                                                                               |
| KVROCKS_URL                           | kvrocks 连接 url                               | 连接 url                         | 空                                                                                                                         |
| REDIS_URL                           | redis 连接 url                               | 连接 url                         | 空                                                                                                                         |
| UPSTASH_URL                         | upstash redis 连接 url                       | 连接 url                         | 空                                                                                                                         |
| UPSTASH_TOKEN                       | upstash redis 连接 token                     | 连接 token                       | 空                                                                                                                         |
| NEXT_PUBLIC_SEARCH_MAX_PAGE         | 搜索接口可拉取的最大页数                     | 1-50                             | 5                                                                                                                          |
| NEXT_PUBLIC_DOUBAN_PROXY_TYPE       | 豆瓣数据源请求方式                           | 见下方                           | direct                                                                                                                     |
| NEXT_PUBLIC_DOUBAN_PROXY            | 自定义豆瓣数据代理 URL                       | url prefix                       | (空)                                                                                                                       |
| NEXT_PUBLIC_DOUBAN_IMAGE_PROXY_TYPE | 豆瓣图片代理类型                             | 见下方                           | direct                                                                                                                     |
| NEXT_PUBLIC_DOUBAN_IMAGE_PROXY      | 自定义豆瓣图片代理 URL                       | url prefix                       | (空)                                                                                                                       |
| NEXT_PUBLIC_DISABLE_YELLOW_FILTER   | 关闭色情内容过滤                             | true/false                       | false                                                                                                                      |
| NEXT_PUBLIC_FLUID_SEARCH | 是否开启搜索接口流式输出 | true/ false | true |


## 使用cloudflare进行部署，用 Upstash 替代,在环境变量中添加：
- NEXT_PUBLIC_STORAGE_TYPE = upstash
- UPSTASH_URL = 你的 HTTPS endpoint
- UPSTASH_TOKEN = 你的 token
