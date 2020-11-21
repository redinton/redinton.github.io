[TOC]

[CS231n Optimizer](<http://cs231n.github.io/neural-networks-3/#ada>)



### SGD

$\theta = \theta - \eta * \nabla_{\theta}J(\theta; x^{i:i+n};y^{i:i+n})$



* adjusting the learning rate during training 
* perform a large update for rarely occurring 
* data is sparse and features has very different frequencies, can't assign update them to the same extent

* avoid trapping in the local minima



### Momentum

* accelerate SGD in the relevant direction and dampens the oscillation

$v_{t} = \gamma v_{t-1} + \eta \nabla_{\theta}J(\theta) $

$\theta = \theta - v_{t}$

a fraction $\gamma$ of the update vector of **past time step** to the **current update** vector, $\gamma$ usually 0.9



* faster convergence and reduced ossillation
  * momentum increase for dimensions whose gradients **point in the same direction** 
  * reduce update for dimension whose **gradients change directions**

  

##### Nesterov (NAG)

The intuition behind this method is "Slow down" the ball when it close to the ball before it roll to the other side again.

$v_{t} = \gamma v_{t-1} + \eta \nabla_{\theta}J(\theta - \gamma v_{t-1})$

The $\theta - \gamma v_{t-1}$ is like the **approximate future position** of  the parameter. Help prevent the param from going too fast.



* Adapt the updates to the **slope of th**e error function and then speed up SGD in return

* Adapt updates to **each individual parameter** to perform **large or small update**s due to their performance



### Update LR

#### Adagrad

* adapt lr to the parameters
  * larger updates for infrequent
  * smaller updates for frequent param

exp

Use adagrad to train Glove word embedding, as infrequent words require much larger updates

The gradient of the objective function with regard to parameter $\theta_{i}$ in time t

$g_{t,i} = \nabla_{\theta_{t}}J(\theta_{t,i})$



Compare to the SGD  $\theta_{t+1,i} = \theta_{t,i} - \eta * g_{t,i}$

$\theta_{t+1,i} = \theta_{t,i} - \frac{\eta}{\sqrt{G_{t,ii}+\epsilon}} * g_{t,i}$

* $G_{t}$  ( $R^{d * d}$ ) is a diagonal  matrix where each diagonal element i , i is the **sum of the squares** of  the **gradients** with regard to $\theta_{i}$ up **to time step t**.
* $\epsilon$  is the smoothing term that **avoids division by zero** (1e-8)
* $G_{t,ii}$ is the diagonal value of index i in the $G_t$ matrix   (I think)



$\theta_{t+1} = \theta_{t} - \frac{\eta}{\sqrt{G_{t}+\epsilon}} \odot g_{t}$ 

##### Main weekness

accumulation of the squared gradients in the denominator

accumulated sum keeps growing

causes the learning rate to shrink and eventually become infinitesimally small,



####Adadelta

Restricts the window of accumulated past gradients to some fixed size w.

adagrad:

```python
cache += dx**2
x += - learning_rate * dx / (np.sqrt(cache) + eps)
```

adadelta:

```python
cache = decay_rate * cache + (1 - decay_rate) * dx**2
x += - learning_rate * dx / (np.sqrt(cache) + eps)
```



#### RMSprop

This is kind like the Adadelta



### Update LR and with momentum

#### Adam

$m_{t} = \beta_{1}m_{t-1}+(1-\beta_{1}) g_{t}$

$v_{t} = \beta_{2}v_{t-1} + (1-\beta_{2}) g_{t}^{2} $



Biased-Corrected

$\hat{m_{t}} = \frac{m_t}{1-\beta_{1}^{t}} $

$\hat{v_{t}} = \frac{v_t}{1-\beta_{2}^{t}} $

$\theta_{t+1} = \theta_{t} - \frac{\eta}{\sqrt{\hat{v}}+\epsilon}\hat{m_t}$



```python
# t is your iteration counter going from 1 to infinity
m = beta1*m + (1-beta1)*dx
mt = m / (1-beta1**t)
v = beta2*v + (1-beta2)*(dx**2)
vt = v / (1-beta2**t)
x += - learning_rate * mt / (np.sqrt(vt) + eps)
```

