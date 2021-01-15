---
title: git_lfs
date: 2020/11/26 15:38:20
toc: true
tags:
- git
---

 Git 大[文件存储](https://cloud.tencent.com/product/cfs?from=10680)（Large File Storage，简称LFS）目的是更好地把大型二进制文件，比如音频文件、数据集、图像和视频等集成到 Git 的工作流中。我们知道，Git 存储二进制效率不高，因为它会压缩并存储二进制文件的所有完整版本，随着版本的不断增长以及二进制文件越来越多，这种存储方案并不是最优方案。而 LFS 处理大型二进制文件的方式是用文本指针替换它们，这些文本指针实际上是包含二进制文件信息的文本文件。文本指针存储在 Git 中，而大文件本身通过HTTPS托管在Git LFS服务器上。



<!--more-->

#### 安装

```
sudo apt/yum install git-lfs` 即可，然后 `git lfs install
```

or

```
$ wget https://github.com/git-lfs/git-lfs/releases/download/v2.2.1/git-lfs-darwin-amd64-2.2.1.tar.gz
$ tar -zxvf git-lfs-darwin-amd64-2.2.1.tar.gz
$ cd git-lfs-2.2.1
$ ./install.sh
```



#### 针对已存在的repo改用git-lfs

对于一个已经用了一段时间的 Git 仓库，直接执行 `git lfs migrate import --include="*.bin" --everything` ，可以将所有本地分支上的匹配文件的提交历史版本都转换为 lfs，这个时候无论你切换到哪个分支，都会出现 `.gitattributes` 文件，且内容都是一样的

> 如果只想更新某个分支的话，可以使用 `git lfs migrate import --include="*.bin" --include-ref=refs/heads/master`

可以通过 `git lfs ls-files` 查看哪些文件被转换成 lfs 了。

切换成功后，就需要把切换之后的本地分支提交到远程仓库了，需要手动 push 更新远程仓库中的各个分支。这里有个极大需要注意的地方，就是转换会更改所有提交的 hash，因此 **push 的时候需要使用 force 选项**，而当其他人员再次使用 pull 去远程拉取的时候会失败。这里当然可以使用 `pull --allow-unrelated-histories` 来把远程仓库被修改的历史与本地仓库历史做合并，但是最好是**重新拉取**。

切换成功后，git 仓库的大小可能并没有变化，主要是之前的提交还在，因此需要做一些清理工作：

```
git reflog expire --expire-unreachable=now --all
git gc --prune=now
```

但是，**如果不是历史记录非常重要的仓库，建议不要像上述这么做，而是重新建立一个新的仓库。个人经验，迁移可以使用，但并没那么美好**。

附一个迁移相关的[基础教程](https://github.com/Git-LFS/Git-LFS/wiki/Tutorial)



#### Git-LFS 需要多次输入密码的问题

解决 Git-LFS 使用导致 push 需要输入多次用户名和密码。

Linux：

```
# Set git to use the credential memory cache
git config --global credential.helper cache

# Set the cache to timeout after 1 hour (setting is in seconds)
git config --global credential.helper 'cache --timeout=3600'
```



#### 追踪和推送

```
git lfs track <file-pattern> 例如 "*.zip"
```

track 会产生一个 `.gitattributes` 文件，和 `.gitignore` 类似，也是 git 自己的文件，用于描述 Git-LFS 的文件名匹配模板。一般而言，文件中的每一行类似这种：

```
*.pbtxt filter=lfs diff=lfs merge=lfs -text
```

`-text` 就是表示这个文件**不是文本文件**。其余的就是告诉 Git 在处理 filter、diff、merge 时将 pbtxt 文件通过 LFS 的方式处理，打开 `.gitconfig` 可以看到相关命令的替换。

用 Git-LFS track 追踪档案之后，就可以添加、提交和推送到远端目录上，你在首次推上去的时候，会要一些时间将大型档案传输到远端。



#### 拉取文件

其他用户使用这个仓库的时候，使用 `git clone` 会拉取普通的文件，但是 LFS 追踪的文件不会被拉下来。如果这些文件本地没有，则需要使用 `git lfs pull` 从远程仓库拉取。

> 现在的 git 貌似是直接能够拉取所有文件，包括 lfs 文件，如果不想拉取 lfs 文件，可以使用 `GIT_LFS_SKIP_SMUDGE=1 git clone`





[Git-LFS 使用和迁移](https://murphypei.github.io/blog/2019/12/git-lfs)

[Git LFS 操作指南](https://zzz.buzz/zh/2016/04/19/the-guide-to-git-lfs/)

[详解 Git 大文件存储（Git LFS）](https://zhuanlan.zhihu.com/p/146683392)

[GitLab 之 Git LFS 大文件存储的配置](https://cloud.tencent.com/developer/article/1010589)