There are two fundamental frameworks: structural causal models and the potential outcome framework

## Structural Causal Models
**Causal Graphs.** A causal graoh forms a special class of Bayesian network with edges representing the causal effect, thus it inherits the well defined conditional independence criterial
**Definition 1. Causal Graph.** A causal graph $G = (V, E)$ is a directed graph that describes the causal effects between varaibles, where $V$ is the node set and $E$ the edge set. In a causal graph, each node represents a random varaible including the treatment, the outcome, other observed and unobserved varaibles. A directed edge $x \to y$ denotes a causal effect of x on y

**Definition 2. Blocked.** We say a node $z$ is blocked by conditioning on a set of nodes $S$ if one of two conditions is satisfied: (1) $z \in S$ and $z$ is not a collider node; (2) $z$ is a collider node, $z \notin S$ and no descendant of $z$ is in $S$


**Structural Equation** Given a causal graph along with a set of structural equations, we can specify the causal effects signified by the directed edges. A set of non-parametric structural equations can quantify the three causal effects shown in the causal graph![avatar](images/Screenshot%202022-03-08%20112234.png)
$$x = f_{x}(\epsilon_{x}), t = f_{t}(x, \epsilon_{t}), y = f_{y}(x, t, \epsilon_{y})$$
epsilons denotes the "noise" of the observed variables, concieved as exogenous or mutually independent sources of unmeasured variation. The noise terms represent the causal effect of unobserved varables on the variable on the LHS

**Definition 3. Interventional Distribution(Post-intervention Distribution).** The interventional distribution $P(y|do(x'))$ denotes the distribution of the variable $y$ when we rerun the modified data-generation process where the value of variable $x$ is set to $x'$
For example, for the causal graph above, the post-intervention distribution $P(y|do(t))$ refers to the distribution of customer flow $y$ as if the rating $t$ is set to $t'$ by interention, where all the arrows into $t$ are removed

**Definition 4. Confounding Bias.** Given varaibles $x, y$, confounding bias exists for causal effect $x \to y$ iff the probabilistic distribution representing the statistical association is not always equivalent to the interventional distribution, i.e, $P(y|x) \neq P(y|do(x))$
**Definition 5. Back-door path.** Given a pair of treatment and outcome varaibles (t, y), we say a path connecting $t$ and $y$ is a back-door path for $(t, y)$ iff it satisfies that (1) it is not a directed path; and (2) it is not blocked (it has no collider)

**Definition 6. Confounder(confounding varaible).** Given a pair of treatment and outcome varaibles $(t, y)$, we say a variable $z \notin {t, y}$  is a confounder iff the central node of a fork and it is on a back-door path of $(t, y)$

To obtain unbiased estimate of causal effects from observational data requires eliminating confounding bias, a procedure referred to as causal identification

**Definition 7. Causal Identification.** We say a causal effect is identified iff the hypothetical distribution(e.g., interventional distribution) that defines the causal effect is formulated as a function of probability distributions over observables.

**Definition 8. Back-door Criterion**. Given a treatment-outcome pair $(t, y)$, a set of features $x$ satisfies the back-door criterion iff conditioning on $x$ can block all back-door paths of $(t, y)$
Using the back-door definition, we can now predict the effect of an intervention with the following theorem:\
**Back-door adjustment** if a set of varaibles $Z$ satisfies the back-door criterion relative to $(X, Y)$, then the causal effect of $X$ on $Y$ is identifiable and given by the formula:
$$P(y|do(X = x)) = \sum_{z}P(Y = y | X = x, Z = z)P(Z = z)


