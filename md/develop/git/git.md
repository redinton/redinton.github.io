[TOC]







### 分支操作

#### 查看当前所有分支

```git
git branch -v 

git branch -a 查看所有分支(包括本地和远程)
git branch -r 查看远程的所有分支
```

#### 创建新的分支

```
git branch <branch name>
```

#### 切换分支

```
git checkout <branch name>
创建并切换到新的分支，copy的内容源自于当前所处的分支
git checkout -b <branch name> 
```

#### 合并分支

```
想要把某分支 bugFix 的代码合并进当前分支
git merge bugFix
```





#### 在提交树(commit 记录) 上移动

* “HEAD” 是一个对当前checkout记录的符号引用 

* HEAD 总是指向当前分支上最近一次提交记录
* 分离的 HEAD 就是让其指向了某个具体的提交记录而不是分支名
  * HEAD -> master -> C1(commit 1)  命令执行前 HEAD指向master,master指向C1
  * 通过 git checkout C1 变成  HEAD-> C1

切换到历史版本

```
git checkout <commit hashcode> 
```



#### 移动分支

```
# 把master分支移到HEAD往上走3步的commit位置
git branch -f master HEAD~3
# 也可以直接指定commit的hash code来移
git branch -f master C6<commit hash code>
```



#### 撤销变更

git reset 把分支记录回退几个提交记录来实现撤销改动。

```
git reset HEAD~1
```

操作结果是版本回退到之前版本，原来的commit就好像没有出现。上述操作对远程分支无效。

git revert 为了撤销更改并**分享**给别人，revert完然后push

```
git revert HEAD 
```

结果是移到一个新的commit，这个commit本质是和想要回退到的那个commit一样。



#### 整理commit

假设有一个稳定版本分支V2.0和一个开发版本V3.0, 现在想要添加V3.0中的某个功能进V2.0。 首先不能直接merge两个分支, 会导致版本紊乱。所以要通过git cherry-pick 来把V3.0的某个commit放到V2.0中。

想将一些提交复制到当前所在的位置（`HEAD`）下面的话

```
git cherry-pick <commit1> <commit2>
commit1 commit2 就会按照顺序接在当前HEAD之后，然后HEAD也会跟着变动
```







#### 提交操作

```
git push <REMOTENAME> <BRANCHNAME>
git push origin master 
// origin 是远程命令, master是远程的分支名称
```

默认情况下，没有其他参数时，`git push` 会发送**所有名称与远程分支相同的匹配**分支。

#### 撤销上一个pull操作

```
1.git reflog 查看历史变更
ed58339 (HEAD -> master, origin/master) HEAD@{0}: commit: before pull branch
3635fd9 HEAD@{1}: commit: 重构日客流量
2a82ab5 HEAD@{2}: commit: 更新同比计算公式
1e4160e HEAD@{3}: commit: 引流数量
7183d2b HEAD@{4}: commit (initial): first commit

2.git reset --hard HEAD@{n} n是你要回退到的引用位置
git reset --hard HEAD@{0} 或者 git reset --hard  ed58339
```

#### 拷贝一个远程分支到本地

```
1. 新建一个file folder
2. git init
3. git remote add origin git@github.com:XXXX/nothing2.git 自己要与origin master建立连接
   git remote add origin http://xyu3@10.127.3.248:7990/scm/san/sanya.git
4. git fetch origin dev（dev为远程仓库的分支名） 把远程分支拉到本地
5. git checkout -b dev(本地分支名称) origin/dev(远程分支名称) 在本地创建分支dev并切换到该分支
6. git pull origin dev(远程分支名称) 把某个分支上的内容都拉取到本地
```



### 创建本地库与远程仓库

在本地的terminal

```
本地仓库创建
mkdir 仓库名称
cd mkdir
git init 
touch readme.md 新建一个readme.md 文件

远程仓库创建
github账户new一个repo,之后copy一下点击创建后生成的git@github.com:redinton/NER_FROM_SCRATCH.git
git remote add origin git@github.com:redinton/NER_FROM_SCRATCH.git
```





#### 添加文件

```
git add . 添加目录下的所有
git add ./data 只添加 data目录下的
git commit -m "写一些修改的东西"
git push origin master
```



```
git pull <远程主机名> <远程分支名>:<本地分支名>

取回origin主机的next分支，与本地的master分支合并
git pull origin next:master

如果远程分支是与当前分支合并，则冒号后面的部分可以省
git pull origin next


```



![image-20200915100247257](git.assets/image-20200915100247257.png)

​	

![image-20200915100234589](git.assets/image-20200915100234589.png)



#### 把stage中的修改还原到work dir中

先将当前`work dir`中的修改添加到`stage`中，然后又对`work dir`中的文件进行了修改，但是又后悔了，如何把`work dir`中的全部或部分文件还原成`stage`中的样子呢？

```
git checkout a.txt # 放弃a的修改，就是还原到上一次commit a的状态 也可以用通配符 . 
```

#### 将stage区的文件还原到work dir中

比如说我用了一个`git add .`一股脑把所有修改加入`stage`，但是突然想起来文件`a.txt`中的代码我还没写完，不应该把它`commit`到`history`区，所以我得把它从`stage`中撤销，等后面我写完了再提交。

如何把`a.txt`从`stage`区还原出来呢？可以使用 **`git reset`** 命令：

```
git reset a.txt # 简写
git reset --mixed HEAD a.txt # 完整写法
```

 #### **将`history`区的历史提交还原到`work dir`中**

从 GitHub 上`clone`了一个项目，然后乱改了一通代码，结果发现我写的代码根本跑不通，于是后悔了，干脆不改了，我想恢复成最初的模样

```
git checkout HEAD .
```

work dir`和`stage`中所有的「修改」都会被撤销，恢复成`HEAD`指向的那个`history commit