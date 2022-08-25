# Coincidence Analysis
## What is Coincidence Analysis(CNA)
- CNA is one method within a class of CCMs(Configurational Comparative Methods) used to model complex patterns of conditions hypothesized to contribute to an outcome within a set of data
- Modern regularity theories of causation define causation in terms of Boolean difference-making within a (comprehensive) set of fixed context factors
- So far, though, CNA has only been available in a crisp-set(take value 0 and 1) variant, some research removes that limitation by generalizing the method for multi-value variables and variables with continuous values from the unit interval that are interpreted as membership scores in fuzzy sets(any value in [0, 1])
- **Example**: simple example is considering a house had fire, and we examine all possible causes: faulty electrical, at night, doo is open, nearby couch, house is big. By CNA, we can idenity only conditions that makes a difference among observed cases, so we can give a regularity expression: $Faulty\:Electrical \wedge Nearby\:couch \implies Fire$
  

## Basic Concept
1. **Sufficiency**: $X$ is sufficient for $Y$ iff $X \implies Y$
2. **Necessity**: $X$ is necessary for $Y$ iff $Y \implies X$
3. **Consistency and Coverage**: As real-life data tend to feature noise induced by unmeasured causes of endogenous factors, strictly sufficient or necessary conditions for an outcome often do not exist. To still extract some causal information from such data, we import *consistency* and *coverage* measures (with values from the interval [0, 1]) into the QCA protocl. *Consistency* reflects the degree to which the behavior of an outcome obeys a corresponding sufficiency or necessity relationship or a whole model, whereas *coverage* reflects the degree to which a sufficiency or necessity relationship or a whole model accounts for the behavior of the corresponding outcome

    In crisp-set, *consistency* and *coverage* are defined as
$$con(X\implies Y) = \frac{|X*Y|}{|X|} \quad cov(X \implies Y) = \frac{|X*Y|}{|Y|}$$




## Categorize
Since our data contains different types of value(continuous, discrete), and CNA has the best result on the crisp and multi-value set, so we manually categorize all the features, and for short, give them index(A, B, C, ...)
- crypto_retransmit_count(A): Since most cases are 0, and only a few cases are greater than 0, so =0 -> 0; >0 and <2 -> 1; >2 -> 2
- first_slowstart_average_rtt(B): the distribution of this variable is more normal, 0-50ms->0; 50-100ms->1; 100-200ms->2
- first_slowstart_max_rtt(C): Similar to previous, 0-300ms -> 0, 300-500ms -> 1, >500ms -> 2
- estimated_bandwidth(D): Since 1mb = 1048576
- stream_first_target_frame_packets_lost(E): Since most cases are 0, but packet loss is acceptable, so we define =0 -> 0, 1~10 -> 1, >10 -> 2
- stream_first_target_frame_tlp_count(F): Since most cases are 0, and we don't want tlp occurs, so we set =0->0, >0->1
- stream_first_target_frame_packets_spuriously_retransmitted(G): Since most cases are 0, and the occurrence of spuriously retransmissoon impacts target hugely, so =0->0, >0 and <2 -> 1, >2 -> 2
- stream_first_target_frame_size(H): in the HD resolution >1280*720*3 = 2764800->2, <2764800 and >144*108*3=46656 -> 1; <46656->0
- stream_first_target_frame_average_estimated_bandwidth(I): >3mb -> 0; 0.5-3mb->1; <0.5mb -> 2
- stream_first_target_frame_completion_time(J): When this time is less than 20ms, we set <20ms -> 0, and mostly cases have 20-100ms, so 20-100ms -> 1, and 100-300ms->2, >300ms -> 3
- first_app_data_effective_ack_cost_time(K): 0-10ms->0, 10-60ms->1, 60-200ms -> 2; >200ms -> 3

## Analysis Result
After transfering all variables into mult-value variables, we can start running coincidence analysis now, and we are focusing on the abnormal range of the completion time, which is >300ms or $J = 3$ category

CNA algorithm is to find all solutions that meet the input consistency and coverage. It starts with single factor value and tests whether they meet consistency and coverag we want; If that is not the case, it proceeds to test conjunctions of two factors values, then to conjunctions of three

```{r}
cna(cna_data, con = 0.5, cov = 0.5,  outcome = c("J=0"))
```
Then we can find some potential causal models:
| Solution       | Consistency |Coverage|
| -------------- | ----------- |-------|
| $A = 2 +  D=3*E=2 + C=2*D=3*I=2 \leftrightarrow J=3$ | 0.687 | 0.664
| $D=3*E=2 + C=2*I=2*K=2 \leftrightarrow J=3$ | 0.669| 0.655 |

For example, consider 𝑋 , 𝑌, By lowering the consistency to 0.8, cna() is given permission to treat 𝑋 as sufficient for 𝑌, even though 20% of the cases 𝑋 is not associated with 𝑌. Or by lowering coverage to 0.8, ```cna()``` is allowed to treat 𝑋 as necessary for  𝑌, even though the sum of the membership scores in 𝑌 over all cases in data exceeds the sum of the membership scores in min⁡(𝑋, 𝑌) by 20%

The aim of CNA is to find the solutions with maximal consistency and coverage scores. Neither threshold should be lowered below 0.75. If the ```cna()``` does not find solutions at con = cov = 0.75, the corresponding data feature such a high degree of noise that causal inferences becomes too hazardous


## High consistency and coverage cases
- When target is in abnormal range, there are too much noise in the causal model, but if we look at the normal range, for example $J = 1$, we can get two reasonable causal models

| Solution       | Consistency |Coverage|
| -------------- | ----------- |-------|
| $D=1*K=1 + B=0*D=1*H=1 + B=1*E=0*K=0 \leftrightarrow J = 1$ | 0.812 | 0.861
| $B=0*K=1 + C=0*K=1 + A=0*B=0*H=1 + B=1*E=0*K=0  \leftrightarrow J=1$ | 0.810| 0.858|

From those two models, almost all features are in acceptable range to make sure that completion time is in acceptable range. This means, when target is normal, most other features will be normal, but when target is abnormal, there will be too much noise in the causal model, which means the possible reasons for abnormal cases are multiple

## Case by case analysis - completion time > 300ms
Since for many cases, the potential root causes can be multiple, so it is hard to label the case what causal model it is suitable for

Consider a specific case:
||A|B|C|D|E|F|G|H|I|J|K|
|-|-|-|-|-|-|-|-|-|-|-|-|
|3|2|3|2|3|0|0|1|1|2|3|2|

The possible cases are:
- $A=2 \leftrightarrow J =3$
- $D=2 \leftrightarrow J =3$
- $A=2 + B = 3 + D =3 \leftrightarrow J =3$
  
Therefore, we can do this by identifying which cases are not possible root causes. Then we can see that we can't find a single case that has completion time over 300ms but crypto retransmit count and estimated bandwidth are both in 0 category.

## Case by case analysis - label the root cause
When we are doing case by case analysis, we want to figure out the root cause for a single abnormal case. We can consider the relationship of each feature in abnormal range and the target in abnormal range first. For example, $A = 2 \leftrightarrow J = 3$ has consistency of 0.943 while $B = 2 \leftrightarrow J = 3$ has consistency of 0.392, that means when $A=2$ occurs, over 94% of cases are $J = 3$ while when $B=2$ occurs, only 39.2% of cases are $J=3$. So we can say that $A = 2$ is very likely to be the root cause while $B = 2$ might be the root cause of $J = 3$, so we can label all the cases that $A = 2 \wedge J = 3$ have the root cause $A = 2$, but we cannot do that for cases that $B = 2 \wedge J = 3$
