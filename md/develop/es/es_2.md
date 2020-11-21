---
title: es_2
date: 2020/11/03 11:49:10
toc: true
tags:
- elasticsearch
---



#### 设置index相关

##### 字段的index为False

```json
"id": {
    "type": "keyword",
    "index": False
},
```

id字段，不会被用于建立inverted index，

index的 not_analyzed选项被丢弃，在es5以后，通过keyword和text来区分字段是否被分词

好处: 节省建立inverted index 时间; 节省inverted index 的存储空间

##### 字段的store为true



#### 精确查找

* 单个精确值查询 term查询

```bash
{
    "term" : {
        "price" : 20
    }
}
```

如果不想对查询结果评分计算，只想包括或排除

```bash
{
    "query" : {
        "constant_score" : { 
            "filter" : {
                "term" : { 
                    "price" : 20
                }
            }
        }
    }
}
```

从概念上，非评分计算首先执行

* 多个精确值查询 terms

```bash
{
    "terms" : {
        "price" : [20, 30]
    }
}
```

term的操作时包含，而不是相等。

{ "term" : { "tags" : "search" } 

```bash
{ "tags" : ["search"] }
{ "tags" : ["search", "open_source"] }
```

第二个文档也会被匹配到。 如果要匹配只包含search的，需要额外增加字段

```sense
{ "tags" : ["search"], "tag_count" : 1 }
{ "tags" : ["search", "open_source"], "tag_count" : 2 }
```

```bash
    "query": {
        "constant_score" : {
            "filter" : {
                 "bool" : {
                    "must" : [
                        { "term" : { "tags" : "search" } }, 
                        { "term" : { "tag_count" : 1 } } 
                    ]
                }
            }
        }
    }
```



#### 范围查询

数值 / 日期  / 字符串

```bash
"range" : {
    "price" : {
        "gte" : 20,
        "lte" : 40
    }
}
```



#### 组合过滤

```bash
{
   "bool" : {
      "must" :     [],
      "should" :   [],
      "must_not" : [],
   }
}
```



#### 多词查询/匹配查询

* 控制query分词后是or 还是and 还是
* 控制匹配的百分比

```bash
{
    "query": {
        "match": {
            "title": "BROWN DOG!"
        }
    }
} 
# 默认是 OR
```

```bash
{
    "query": {
        "match": {
            "title": {      
                "query":    "BROWN DOG!",
                "operator": "and"
            }
        }
    }
}
```

```
{
  "query": {
    "match": {
      "title": {
        "query":                "quick brown dog",
        "minimum_should_match": "75%"
      }
    }
  }
}
```



#### 组合查询

```bash
{
  "query": {
    "bool": {
      "must":     { "match": { "title": "quick" }},
      "must_not": { "match": { "title": "lazy"  }},
      "should": [
                  { "match": { "title": "brown" }},
                  { "match": { "title": "dog"   }}
      ]
    }
  }
}
```



* should 中的词 不必被匹配，但一旦匹配到则认为更相关

* must not 不影响分数，只是剔除不相关的文档
* 评分计算
  * `bool` 查询会为每个文档计算相关度评分 `_score` ，再将所有匹配的 `must` 和 `should` 语句的分数 `_score` 求和，最后除以 `must` 和 `should` 语句的总数

所有 `must` 语句必须匹配，所有 `must_not` 语句都必须不匹配，但有多少 `should` 语句应该匹配呢？默认情况下，没有 `should` 语句是必须匹配的，只有一个例外：那就是当没有 `must` 语句的时候，至少有一个 `should` 语句必须匹配。

* `minimum_should_match` 参数控制需要匹配的 `should` 语句的数量，它既可以是一个绝对的数字，又可以是个百分比：



#### 查询语句提升权重

场景：query中出现某些特定的词后，提升匹配到的文档的分数

```bash
{
    "query": {
        "bool": {
            "must": {
                "match": {
                    "content": { 
                        "query":    "full text search",
                        "operator": "and"
                    }
                }
            },
            "should": [ 
                { "match": { "content": "Elasticsearch" }},
                { "match": { "content": "Lucene"        }}
            ]
        }
    }
}
```

```bash
{
    "query": {
        "bool": {
            "must": {
                "match": {  
                    "content": {
                        "query":    "full text search",
                        "operator": "and"
                    }
                }
            },
            "should": [
                { "match": {
                    "content": {
                        "query": "Elasticsearch",
                        "boost": 3 
                    }
                }},
                { "match": {
                    "content": {
                        "query": "Lucene",
                        "boost": 2 
                    }
                }}
            ]
        }
    }
}
```

#### 分词器的配置

索引时：

字段可以定义分词器

索引(index) 可以定义分词器

全局缺省 global default

搜索时：

查询自己定义的analyzer

字段映射里定义的search-analyzer

字段映射里的analyzer

索引中的default_search

索引中的default 

standard 标准分词器





针对同一个字段，配置不同的分词器





#### 多字段查询

某个index中有多个字段支持搜索。

```
{
    "query": {
        "bool": {
            "should": [
                { "match": { "title": "Brown fox" }},
                { "match": { "body":  "Brown fox" }}
            ]
        }
    }
}
针对title，body字段搜索， 这种匹配分数的算法是
* 它会执行 should 语句中的两个查询。
* 加和两个查询的评分。
* 乘以匹配语句的总数。
* 除以所有语句总数（这里为：2）。
可能有的情况就是title，body各有一个匹配到的结果(title,body中都只有一个brown)的分数，高于只有title中完全匹配(brown fox)的结果。 因此改用 dis_max
```

单个最佳匹配字段 的评分

```
{
    "query": {
        "dis_max": {
            "queries": [
                { "match": { "title": "Brown fox" }},
                { "match": { "body":  "Brown fox" }}
            ]
        }
    }
}
```

tie_breaker指标 提供介乎 dis_max 和 bool之间的折中。

1. 获得最佳匹配语句的评分 `_score` 。
2. 将其他匹配语句的评分结果与 `tie_breaker` 相乘。
3. 对以上评分求和并规范化

tie越小，最佳匹配的权重越高

#### multi_match

多个字段执行相同查询

```
{
  "dis_max": {
    "queries":  [
      {
        "match": {
          "title": {
            "query": "Quick brown fox",
            "minimum_should_match": "30%"
          }
        }
      },
      {
        "match": {
          "body": {
            "query": "Quick brown fox",
            "minimum_should_match": "30%"
          }
        }
      },
    ],
    "tie_breaker": 0.3
  }
}
```



```bash
{
    "multi_match": {
        "query":                "Quick brown fox",
        "type":                 "best_fields", 
        "fields":               [ "title", "body" ],
        "tie_breaker":          0.3,
        "minimum_should_match": "30%" 
    }
}
```



#### 多字段映射

针对同一字段，索引多次，用multifields实现

```bash
PUT /my_index
{
    "settings": { "number_of_shards": 1 }, 
    "mappings": {
        "my_type": {
            "properties": {
                "title": { 
                    "type":     "string",
                    "analyzer": "english",
                    "fields": {
                        "std":   { 
                            "type":     "string",
                            "analyzer": "standard"
                        }
                    }
                }
            }
        }
    }
}
```



#### 短语匹配

有时候，搜索结果不止需要query中的词都出现，而且还需要query中词出现的位置顺序不变，且尽可能距离近

```bash
{
    "query": {
        "match_phrase": {
            "title": "quick brown fox"
            "slop":  1
        }
    }
}
```

* `match_phrase` 查询首先将查询字符串解析成一个词项列表，
* 然后对这些词项进行搜索，但只保留那些**包含 *全部* 搜索词**项，且 *位置* 与搜索词项相同的文档

* 通过slop控制查询词条相隔多远时仍然能将文档视为匹配 。 相隔多远的意思是为了让查询和文档匹配你需要移动词条多少次，**而且只要slop值大，词的顺序也可以不一样(**但要保证词都出现)



#### 邻近度提升权重

短语匹配 slop 这个要求过于严苛，需要query分词后的所有结果都出现

可以用bool组合型来查 短语匹配作为提分项

```bash
{
  "query": {
    "bool": {
      "must": {
        "match": { 
          "title": {
            "query":                "quick brown fox",
            "minimum_should_match": "30%"
          }
        }
      },
      "should": {
        "match_phrase": { 
          "title": {
            "query": "quick brown fox",
            "slop":  50
          }
        }
      }
    }
  }
}
```

#### 性能优化

针对所有的结果用match_phrase来算的话，花费时间远高于仅仅match

策略，可以先用match筛选出相关的结果，然后在筛选的结果中用match_phrase来重排

```bash
{
    "query": {
        "match": {  
            "title": {
                "query":                "quick brown fox",
                "minimum_should_match": "30%"
            }
        }
    },
    "rescore": {
        "window_size": 50, 
        "query": {         
            "rescore_query": {
                "match_phrase": {
                    "title": {
                        "query": "quick brown fox",
                        "slop":  50
                    }
                }
            }
        }
    }
}
```

#### 查找相关词

在 customize 分词器的时候， 可以自定义分词粒度，本来是unigram，可以控制生成bigram，利于匹配更接近的文档。



