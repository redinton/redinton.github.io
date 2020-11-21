[TOC]



### SentiGAN

SentiGAN: Generating Sentimental Texts via Mixture Adversarial Networks



* 多个生成器和一个**多类别判别**器。
* 多个生成器同时训练，旨在无监督环境下产生不同情感标签的文本。
* 提出了一个基于惩罚的目标函数，使每个生成器都能在特定情感标签下生成具有多样性的样本



![image-20190411185819365](/Users/K/Library/Application Support/typora-user-images/image-20190411185819365.png)



* 判别器的目标，是**区分生成文本和 k 类真实文本**，因此我们采用**多类别分类**目标函数



* 损失函数

  * $L(X)=G_{i}\left(X_{t+1} | S_{t} ; \theta_{g}^{i}\right) \cdot V_{D_{i}}^{G_{i}}\left(S_{t}, X_{t+1}\right)$ 其中 $V_{D_{i}}^{G_{i}}\left(S_{t}, X_{t+1}\right)$ 是区别器对序列$X_{1:t+1}$的惩罚项,即判别器**判别该序列是假**的概率 ,$G_{i}\left(X_{t+1} | S_{t} ; \theta_{g}^{i}\right)$ 是基于当前状态$S_{t}$ 从词库中选择t+1个词的概率,那么针对第i个生成器$G_{i}\left(X | S ; \theta_{g}^{i}\right)​$ 来说

  $J_{G_{i}}\left(\theta_{g}^{i}\right)=\mathbb{E}_{X \sim P_{g_{i}}}[L(X)] =\sum_{t=0}^{t=|X|-1} G_{i}\left(X_{t+1} | S_{t} ; \theta_{g}^{i}\right) \cdot V_{D_{i}}^{G_{i}}\left(S_{t}, X_{t+1}\right)​$  



#### mode collapse

模型生成的样本单一，认为满足某一分布的结果为 true，其他为 False，导致以上结果。

缓解mode collapse 问题 - 提出新的目标函数，通过**最小化整体损失而不是最大化奖励**来优化模型



* 对于SeqGAN来说，通过最大化$D(X;\theta_{d})$ 判别器判定的值, 即最小化目标函数来实现。
* 对于sentiGAN来说，将**Discriminator 判断为假的概率作为惩罚**，Generator 通过最小化惩罚来更新自己，并且去掉了log。缓解了mode collapse
  * 作者解释 去掉 log，可以视作 WGAN 中的 generator loss（这一点我持怀疑态度，因为代码中并没有对梯度进行裁剪来满足 WGAN 所需的 Lipschitz 条件）
  * 惩罚和奖赏存在一个 1−V = D的关系，根据 $G\left(X | S ; \theta_{g}\right) V(X)=G\left(X | S ; \theta_{g}\right)\left(1-D\left(X ; \theta_{d}\right)\right)=G\left(X | S ; \theta_{g}\right)-G\left(X | S ; \theta_{g}\right) D\left(X ; \theta_{g}\right)$会让generator偏向于更小的$G\left(X | S ; \theta_{g}\right)$ , 即生成概率比较小的句子，从而避免生成很多重复的(概率比较大的)句子。

$J_{G}(X)=\left\{\begin{array}{ll}{\mathbb{E}_{X \sim P_{g}}\left[-\log \left(D\left(X ; \theta_{d}\right)\right)\right]} & {\text { GAN }} \\ {\mathbb{E}_{X \sim P_{g}}\left[-\log \left(G(X | S ; \theta g) D\left(X ; \theta_{d}\right)\right)\right]} & {\text { SeqGAN }} \\ {\mathbb{E}_{X \sim P_{g}}\left[G\left(X | S ; \theta_{g}\right) V(X)\right]} & {\text { SentiGAN }}\end{array}\right.​$





#### Convergence

难收敛



####Reference

[1.中文翻译本文](<https://xueqiu.com/9217191040/110857686>)

